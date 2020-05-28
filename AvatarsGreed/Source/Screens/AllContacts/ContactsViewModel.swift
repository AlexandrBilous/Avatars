//
//  ContactsViewModel.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol ContactsViewModel {
    /// Total amount of getched users
    var usersCount : Int { get }
    /// Calback if users list has changes
    var usersListDidChange : (() -> Void)? { get set}
    ///
    var didFailLoad : (() -> Void)? { get set}
    /// Show new controller with given gavatar
    func showAvatarDelails(for indexPath: IndexPath, originFrame : CGRect)
    /// Generate changes in current model and fetch new gvatar accounts from network
    func simulateChanges()
    /// Name for user with given index
    func nameForIndex(_ index : Int) -> String
    /// Statuc image for user with given index
    func statusForIndex(_ index : Int) -> UIImage
    /// Fetch image for given index from network or cache
    func imageForIndex(_ index : Int, onSuccess : @escaping (UIImage?) -> Void)
    /// Remove users at specific index
    func removeUser(_ index : Int)
}

final class ContactsViewModelImplemetation : ContactsViewModel {
    private let networkService : NetworkService
    private let userStorageService : UsersStorageService
    private var batchCount : Int = 0
    private var users : [User] = [] {
        didSet {
            if users.count > 0 && users.count % batchCount == 0, let callbackAction = usersListDidChange {
                callbackAction()
            }
        }
    }
    var usersListDidChange : (() -> Void)?
    var didFailLoad : (() -> Void)?
    var usersCount : Int { users.count }
    weak var coordinator : AppCoordinator?
    
    init(networkService : NetworkService = AppDelegate.shared.context.networkService,
         userStorageService : UsersStorageService = AppDelegate.shared.context.usersStorageService) {
        self.networkService = networkService
        self.userStorageService = userStorageService
    }
    
    func showAvatarDelails(for indexPath: IndexPath, originFrame : CGRect) {
        let user = getUser(at: indexPath.row)
        imageForIndex(indexPath.row) { [weak self] (image) in
            self?.coordinator?.showSingleContact(user: user, image: image,  originFrame : originFrame)
        }
        
    }
    
    func simulateChanges() {
        users = users.map { User(user: $0) }.shuffled()
        batchCount = Int.random(in: 40...80)
        userStorageService.generateRandomUserEmails(batchCount) { [weak self] emailsList in
            emailsList.forEach ({ value in
                self?.networkService.fetchGvatarUser(with: value, onSuccess: { [weak self] (gvatarUser) in
                    let user = User(gvatarProfile: gvatarUser, email: value)
                    self?.users.append(user)
                }) { [weak self] (error) in
                    if let callback = self?.didFailLoad {
                        callback()
                    }
                    self?.batchCount -= 1
                }
            })
        }
    }
    
    func nameForIndex(_ index : Int) -> String {
        return users[index].fullName
    }
    
    func statusForIndex(_ index : Int) -> UIImage {
        return users[index].status == Status.online ? #imageLiteral(resourceName: "online") : #imageLiteral(resourceName: "offline")
    }
    
    func imageForIndex(_ index : Int, onSuccess : @escaping (UIImage?) -> Void) {
        networkService.fetchGvatarImage(with: users[index].email, onSuccess: { (image) in
            onSuccess(image)
        }) { [weak self] (error) in
            if let callback = self?.didFailLoad {
                callback()
            }
        }
    }
    
    func removeUser(_ index : Int) {
        users.remove(at: index)
    }
    
    private func getUser(at index: Int) -> User {
        return users[index]
    }
}
