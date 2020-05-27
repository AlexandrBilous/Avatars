//
//  GvatarUser.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation


// MARK: User Model
struct GvatarUser : Decodable {
    let entry : [Entry]
    
    enum CodingKeys : String, CodingKey {
        case entry
    }
}

// MARK: - Entry
struct Entry : Decodable {
    let displayName: String
    let hash : String
    let thumbnailUrl : String
    
    enum CodingKeys : String, CodingKey {
        case displayName, hash, thumbnailUrl
    }
}
