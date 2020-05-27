//
//  SingleContactViewController.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleContactViewController : UIViewController {
    private let viewModel : SingleContactViewModel
    private let singleContactView : SingleContactView
    private let originFrame : CGRect
    private let backButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setAttributedTitle(NSAttributedString(string: Strings.back,
                                                  attributes: String.attributedString(font: Font.text.uiFont,
                                                                                      txtColor: UIColor.systemBlue)),for: .normal)
        return btn
    } ()
    
    var avatarFrame : CGRect {
        let frame = singleContactView.avatarFrame
        let statusBarHeigh = UIApplication.shared.statusBarFrame.size.height
        return CGRect(x: frame.origin.x + Space.double, y: frame.origin.y + Space.double + statusBarHeigh, width: frame.width, height: frame.height)
    }
    
    init(viewModel : SingleContactViewModel, originFrame : CGRect) {
        self.originFrame = originFrame
        self.viewModel = viewModel
        self.singleContactView = SingleContactView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        transitioningDelegate = self
        backButton.addTarget(self, action: #selector(backButtonDidPress(sender:)), for: .touchUpInside)
        [singleContactView, backButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            singleContactView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.double),
            singleContactView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.double),
            singleContactView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.double),
            singleContactView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Space.double),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.double),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Space.double)
        ])
        
        singleContactView.configure(image: viewModel.image,
                                             name: self.viewModel.name,
                                             status: self.viewModel.status,
                                             email: self.viewModel.email)
    }
}

// MARK: - Actions
@objc
private extension SingleContactViewController {
    func backButtonDidPress(sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK : - UIViewControllerTransitioningDelegate
extension SingleContactViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmoothPresentAnimationController(image: viewModel.image, originFrame: originFrame, destenationFrame: avatarFrame)
    }
    
    func  animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmoothDismissAnimationController(image: viewModel.image, originFrame: avatarFrame, destenationFrame: originFrame)
    }
}
