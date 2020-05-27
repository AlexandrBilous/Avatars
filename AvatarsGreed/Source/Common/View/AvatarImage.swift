//
//  AvatarImage.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class AvatarImage : UIView {
    private let borderWidth : CGFloat
    private let avatarImageView : UIImageView
    private let statusImageView : UIImageView
    
    init(borderWidth : CGFloat) {
        self.borderWidth = borderWidth
        self.avatarImageView = UIImageView()
        self.statusImageView = UIImageView()
        super.init(frame: .zero)
        addSubview(avatarImageView)
        addSubview(statusImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure (image : UIImage?, status : UIImage? = nil) {
        avatarImageView.image = image
        statusImageView.image = status
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.frame = bounds
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = frame.height / 2
        avatarImageView.layer.borderWidth = borderWidth
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.clipsToBounds = true
        statusImageView.frame = CGRect(x: frame.width * 3 / 4, y: frame.height  * 3 / 4, width: 10, height: 10)
    }
}
