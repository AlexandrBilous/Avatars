//
//  AppCoordinator.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController : UINavigationController { get }
    func start()
}

final class AppCoordinator : NSObject, Coordinator {
    var navigationController: UINavigationController
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let viewModel = ContactsViewModelImplemetation()
        viewModel.coordinator = self
        let rootVC = ContactsViewController(viewModel: viewModel)
        navigationController.setViewControllers([rootVC], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showSingleContact(user: User, image : UIImage?, originFrame : CGRect) {
        let singleContactModel = SingleContactViewModelImplementation(user: user, image: image)
        let vc = SingleContactViewController(viewModel: singleContactModel, originFrame: originFrame)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true, completion: nil)
    }
}

