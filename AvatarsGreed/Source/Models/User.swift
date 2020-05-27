//
//  User.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

// MARK: - Status
enum Status : Int {
    case online = 0
    case offline
}

// MARK: - User
struct User {
    let fullName : String
    let email : String
    var status : Status
    let avatarUrl : String
    
    init(gvatarProfile : GvatarUser, email: String) {
        self.email = email
        self.status = .online
        self.fullName = gvatarProfile.entry.first?.displayName ?? "nil"
        self.avatarUrl = gvatarProfile.entry.first?.thumbnailUrl ?? "nil"
        generateStatus()
    }
    
    init(user : User) {
        self.email = user.email
        self.status = .online
        self.fullName = user.fullName
        self.avatarUrl = user.avatarUrl
        generateStatus()
    }
    
    mutating func generateStatus () {
        status = Int.random(in: 0...100) > 60 ? .online : .offline
    }
}
