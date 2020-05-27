//
//  UserStorageService.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

struct Emails : Codable {
    let email : [String]
    
    enum CodingKeys : String, CodingKey {
        case email
    }
}

protocol UsersStorageServiceHolder {
    var usersStorageService : UsersStorageService { get }
}

protocol UsersStorageService {
    /// Read data from disk and return random user emails
    func generateRandomUserEmails(_ amount: Int, onSuccess: @escaping ([String]) -> Void)
}

final class UsersStorageServiceImplementation : UsersStorageService {
    
    func generateRandomUserEmails(_ amount: Int, onSuccess: @escaping ([String]) -> Void) {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "all", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []),
                let emails = Serializer.deserialize(data: data, model: Emails.self) {
                DispatchQueue.main.async {
                    onSuccess(emails.email.shuffled().prefix(amount).map { $0 } )
                }
            }
        }
    }
}
