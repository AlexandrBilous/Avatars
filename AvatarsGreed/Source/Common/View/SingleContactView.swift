//
//  SingleContactView.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleContactView : UIView {
    private let imageView = AvatarImage(borderWidth: ImageBorders.medium)
    private let nameLabel = Label.makeTitleLabel()
    private let statusLabel = Label.makeStatusLabel()
    private let emailLabel = Label.makeEmailLabel()
    
    var avatarFrame : CGRect {
        layoutIfNeeded()
        return imageView.frame
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        [imageView, nameLabel, statusLabel, emailLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Space.double * 4),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Space.double),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.single),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.single),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Space.single),
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            emailLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Space.single),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.single),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.single),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(image : UIImage?, name: String, status : String, email : String) {
        imageView.configure(image: image)
        nameLabel.text = name
        statusLabel.text = status
        emailLabel.text = email
    }
}
