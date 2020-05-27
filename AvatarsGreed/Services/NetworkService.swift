//
//  NetworkService.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol NetworkServiceHolder {
    var networkService : NetworkService { get }
}

protocol NetworkService {
    /// Send request to server and return responce on main thread
    func fetchGvatarUser(with email : String, onSuccess : @escaping (GvatarUser) -> Void, onFailure : @escaping (Error?) -> Void )
    /// Fetch existing user image from server or cache if data has been already loaded
    func fetchGvatarImage(with email : String, onSuccess : @escaping (UIImage?) -> Void, onFailure : @escaping (Error?) -> Void )
}

final class NetworkServiceImplementation : NetworkService {
    private let urlSession : URLSession
    private let cache : NSCache<NSString, AnyObject>
    
    init(urlSession : URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.cache = NSCache<NSString, AnyObject>()
    }
    
    func fetchGvatarUser(with email : String, onSuccess : @escaping (GvatarUser) -> Void, onFailure : @escaping (Error?) -> Void ) {
        let urlRequest = makeRequest(with: Host.user, and: email.md5(), responce: Responce.json)
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, responce, error) in
            guard let responceData = data, error == nil,
                let gvatarUser = Serializer.deserialize(data: responceData, model: GvatarUser.self) else {
                DispatchQueue.main.async {
                    onFailure(error)
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess(gvatarUser)
            }
        }
        dataTask.resume()
    }
    
    func fetchGvatarImage(with email : String, onSuccess : @escaping (UIImage?) -> Void, onFailure : @escaping (Error?) -> Void ) {
        DispatchQueue.global().async { [weak self] in
            guard let image = self?.cache.object(forKey: NSString(string: email)) as? UIImage else {
                self?.loadImage(with: email, onSuccess: onSuccess, onFailure: onFailure)
                return
            }
            DispatchQueue.main.async {
                onSuccess(image)
            }
        }
        
    }
    
    private func loadImage(with email : String, onSuccess : @escaping (UIImage?) -> Void, onFailure : @escaping (Error?) -> Void) {
        let urlRequest = makeRequest(with: Host.avatar, and: email.md5(), responce: Responce.largePhoto)
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, responce, error) in
            guard let responceData = data, error == nil, let image = UIImage(data: responceData) else {
                DispatchQueue.main.async {
                    onFailure(error)
                }
                return
            }
            self.cache.setObject(image, forKey: NSString(string: email))
            DispatchQueue.main.async {
                onSuccess(image)
            }
        }
        dataTask.resume()
    }
}

private extension NetworkServiceImplementation {
    enum Constants {
        static let jsonType = ".json"
        static let smallPhotoType = "?s=100"
        static let largePhotoType = "?s=400"
        static let userHost = "https://ru.gravatar.com/"
        static let avatarHost = "https://secure.gravatar.com/avatar/"
    }
    
    enum Host {
        case user
        case avatar
        
        var storedHost : String {
            switch self {
            case .user: return Constants.userHost
            case .avatar: return Constants.avatarHost
            }
        }
    }
    
    enum Responce {
        case json
        case smallPhoto
        case largePhoto
        
        var storedResponce : String {
            switch self {
            case .json: return Constants.jsonType
            case .smallPhoto: return Constants.smallPhotoType
            case .largePhoto: return Constants.largePhotoType
            }
        }
    }
    
    func makeRequest(with host : Host, and url : String, responce : Responce) -> URLRequest {
        guard let url = URL(string: "\(host.storedHost)\(url)\(responce.storedResponce)") else { fatalError() }
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        return urlRequest
    }
}
