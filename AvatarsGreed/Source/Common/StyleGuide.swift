//
//  StyleGuide.swift
//  AvatarsGreed
//
//  Created by Marentilo on 25.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

enum Space {
    static let single : CGFloat = 10
    static let double : CGFloat = 20
}

enum ImageBorders {
    static let small : CGFloat = 2
    static let medium : CGFloat = 5
}

enum CellHeight {
    static let tableView : CGFloat = 50
    static let collectionView : CGFloat = 50
}

enum Font {
    case title
    case subtitle
    case text
    
    var uiFont : UIFont {
        switch self {
        case .title: return UIFont.systemFont(ofSize: 30)
        case .subtitle: return UIFont.systemFont(ofSize: 24)
        case .text: return UIFont.systemFont(ofSize: 20)
        }
    }
}
