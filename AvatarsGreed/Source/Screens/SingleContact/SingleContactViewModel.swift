//
//  SingleContactViewModel.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol SingleContactViewModel {
    var name : String { get }
    var status : String { get }
    var email : String { get }
    var image : UIImage? { get }
    
}

final class SingleContactViewModelImplementation : SingleContactViewModel {
    private let user : User
    var image : UIImage?
    var name : String { user.fullName }
    var email : String { user.email }
    var status : String {
        switch user.status {
        case .online: return Strings.online
        case .offline: return Strings.offline
        }
    }
    
    init(user : User, image : UIImage?) {
        self.user = user
        self.image = image
    }
}
