//
//  ContactTableViewCell.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    private let avatarView = AvatarImage(borderWidth: ImageBorders.small)
    private let statusView = UIImageView()
    private let nameLabel = Label.makeCellTitleLabel()
    
    var avatar : UIView {
        get { avatarView }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.configure(image: nil, status: nil)
        statusView.image = nil
        nameLabel.text = nil
    }
    
    private func setupView() {
        avatarView.contentMode = .scaleAspectFit
        [avatarView, statusView, nameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constrains = [
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: Space.double * 2),
            avatarView.heightAnchor.constraint(equalToConstant: Space.double * 2),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Space.double),
            
            statusView.heightAnchor.constraint(equalToConstant: Space.single),
            statusView.widthAnchor.constraint(equalToConstant: Space.single),
            statusView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: -Space.single),
            statusView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -Space.single / 2 + ImageBorders.small),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: Space.double),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Space.double)
        ]
        
        NSLayoutConstraint.activate(constrains)
    }
    
    func configure(avatar : UIImage?, status: UIImage?, name: String) {
        avatarView.configure(image: avatar, status: status)
        nameLabel.text = name
    }
}
