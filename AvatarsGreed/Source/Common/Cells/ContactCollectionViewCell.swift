//
//  ContactCollectionViewCell.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class ContactCollectionViewCell : UICollectionViewCell {
    private let avatarView = AvatarImage(borderWidth: ImageBorders.small)
    private let statusView = UIImageView()
    
    var avatar : UIView {
        get { avatarView }
    }
    
    override init(frame: CGRect) {
        avatarView.contentMode = .scaleAspectFill
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.configure(image: nil, status: nil)
    }
    
    private func setupView() {
        [avatarView, statusView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            avatarView.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            avatarView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            statusView.heightAnchor.constraint(equalToConstant: Space.single),
            statusView.widthAnchor.constraint(equalToConstant: Space.single),
            statusView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: -Space.single),
            statusView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -Space.single / 2 + ImageBorders.small)
        ])
    }
    
    func configure(image : UIImage?, statusImage : UIImage?) {
        avatarView.configure(image: image, status: statusImage)
    }
}
