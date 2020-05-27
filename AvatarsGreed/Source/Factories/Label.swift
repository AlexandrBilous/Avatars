//
//  Label.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Label {
    static func makeEmailLabel() -> UILabel {
        UILabel()
            .font(Font.subtitle.uiFont)
            .alignment(.center)
            .color(UIColor.blue)
            .lines(0)
            .lineBreakMode(.byWordWrapping)
    }
    
    static func makeStatusLabel() -> UILabel {
        UILabel()
            .font(Font.subtitle.uiFont)
            .alignment(.center)
            .color(UIColor.black)
    }
    
    static func makeTitleLabel() -> UILabel {
        UILabel()
            .font(Font.title.uiFont)
            .alignment(.center)
            .color(UIColor.black)
            .lines(2)
            .lineBreakMode(.byWordWrapping)
    }
    
    static func makeCellTitleLabel() -> UILabel {
        UILabel()
               .font(Font.text.uiFont)
               .alignment(.left)
               .color(UIColor.black)
    }
}

extension UILabel {
    func font(_ fnt: UIFont) -> UILabel {
        font = fnt
        return self
    }
    
    func color(_ clr: UIColor) -> UILabel {
        textColor = clr
        return self
    }
    
    func alignment(_ aln : NSTextAlignment) -> UILabel {
        textAlignment = aln
        return self
    }
    
    func lines(_ lns : Int) -> UILabel {
        numberOfLines = lns
        return self
    }
    
    func lineBreakMode(_ breakMode : NSLineBreakMode) -> UILabel {
        lineBreakMode = breakMode
        return self
    }
}
