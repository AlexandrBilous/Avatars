//
//  Strings.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

final class Strings {
    static let list = Strings.tr("Localizable", "list")
    static let grid = Strings.tr("Localizable", "grid")
    static let changes = Strings.tr("Localizable", "changes")
    static let back = Strings.tr("Localizable", "back")
    static let online = Strings.tr("Localizable", "online")
    static let offline = Strings.tr("Localizable", "offline")
    static let noInternet = Strings.tr("Localizable", "noInternet")
    static let tryLater = Strings.tr("Localizable", "tryLater")
    static let cancel = Strings.tr("Localizable", "cancel")
}

extension Strings {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle.main, comment: "")
        let result = String(format: format, locale: Locale.current, arguments: args)
        return result
    }
}
