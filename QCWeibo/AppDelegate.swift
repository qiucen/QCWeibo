//
//  AppDelegate.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        printQCDebug(message: UserAccountViewModel.shared.account)
        
        setApperance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        
        // `add observer`
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(kSwitchRootViewControllerNotification),
            object: nil,
            queue: nil
        ) {
            [weak self] (notification) in
            let vc = notification.object != nil ? WelcomeViewController() : MainViewController()
            self?.window?.rootViewController = vc
        }

        return true
    }
    

    deinit {
        // `remove observer`
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(kSwitchRootViewControllerNotification),
            object: nil
        )
    }
    
    /// `set apperance`
    private func setApperance() {
        UINavigationBar.appearance().tintColor = KAppearanceTintColor
        UITabBar.appearance().tintColor = .black//KAppearanceTintColor
    }


}

extension AppDelegate {
    
    private var defaultRootViewController: UIViewController {
        if UserAccountViewModel.shared.userLogin {
            return WelcomeViewController()
        }
        return MainViewController()
    }
}

