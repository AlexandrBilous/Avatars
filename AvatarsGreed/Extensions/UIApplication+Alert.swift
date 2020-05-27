//
//  UIViewController+Alert.swift
//  AvatarsGreed
//
//  Created by Marentilo on 27.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIApplication {
    static func showAlert(title : String, message : String, cancel : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .destructive, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
