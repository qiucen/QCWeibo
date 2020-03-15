//
//  MainViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `main view controller`
class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addControllers()
    }
   

}

extension MainViewController {
    
    
    
    /// `add view controllers`
    private func addControllers() {
           addViewController(vc: HomeTableViewController(), title: "微博", imageName: "tabbar_home", selectedImageName: "tabbar_home_selected")
           addViewController(vc: VideoViewController(), title: "视频", imageName: "tabbar_video", selectedImageName: "tabbar_video_selected")
           addViewController(vc: DiscoveryViewController(), title: "发现", imageName: "tabbar_discover", selectedImageName: "tabbar_discover_selected")
           addViewController(vc: MessageViewController(), title: "消息", imageName: "tabbar_message_center", selectedImageName: "tabbar_message_center_selected")
           addViewController(vc: ProfileViewController(), title: "我", imageName: "tabbar_profile", selectedImageName: "tabbar_profile_selected")
       }

       /// `add view controller`
       private func addViewController(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
           vc.title = title
           vc.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
           vc.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
           let nav = UINavigationController(rootViewController: vc)
           addChild(nav)
       }
}
