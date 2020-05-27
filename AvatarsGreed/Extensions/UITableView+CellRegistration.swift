//
//  UITableView+CellRegistration.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UITableView {
    func registerReusableCell<T : UITableViewCell>(_ cellType : T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.description())
    }
    
    func dequeueReusableCell<T : UITableViewCell>(_ cellType : T.Type) -> T? {
        dequeueReusableCell(withIdentifier: cellType.description()) as? T
    }
}
