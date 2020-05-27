//
//  AppDelegate.swift
//  AvatarsGreed
//
//  Created by Marentilo on 21.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol AppDelegateProtocol {
    var coordinator : Coordinator! { get }
    var context : AppContextProtocol! { get }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateProtocol {
    static let shared = UIApplication.shared.delegate as! AppDelegateProtocol
    var window: UIWindow?
    var coordinator : Coordinator!
    var context : AppContextProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        context = Context.context()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        coordinator = AppCoordinator(window: window)
        coordinator.start()
        return true
    }
}

