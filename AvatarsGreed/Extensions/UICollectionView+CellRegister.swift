//
//  UICollectionView+CellRegister.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerReusableCell<T : UICollectionViewCell>(_ cellType : T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.description())
    }
    
    func dequeueReusableCell<T : UICollectionViewCell>(_ cellType : T.Type, for indexPath : IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: cellType.description(), for: indexPath) as? T
    }
}
