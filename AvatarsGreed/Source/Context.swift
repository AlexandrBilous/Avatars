//
//  AppContext.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

typealias AppContextProtocol = NetworkServiceHolder &
                                UsersStorageServiceHolder

struct Context : AppContextProtocol {
    let networkService: NetworkService
    let usersStorageService: UsersStorageService
    
    static func context() -> Context {
        let networkService = NetworkServiceImplementation()
        let usersStorageService = UsersStorageServiceImplementation()
        return Context(networkService: networkService,
                          usersStorageService: usersStorageService)
    }
}
