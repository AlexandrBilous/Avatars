//
//  String.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CryptoKit

// MARK: - NSAttributedString
extension String {
    static func attributedString(font : UIFont?, txtColor : UIColor?) -> [NSAttributedString.Key : AnyObject]{
        var attributedString = [NSAttributedString.Key : AnyObject]()
        if let givenFont = font {
            attributedString[.font] = givenFont
        }
        if let givenColor = txtColor {
            attributedString[.foregroundColor] = givenColor
        }
        return attributedString
    }
}

// MARK: String to MD5 value
extension String {
    func md5() -> String {
        guard let data = self.data(using: .utf8) else { return "not a valid Sequence" }
        var hash = Insecure.MD5.hash(data: data).description
        let validateString = "MD5 digest: "
        if let range = hash.range(of: validateString) {
            hash = hash.replacingCharacters(in: range, with: "")
        }
        return hash
    }
}
