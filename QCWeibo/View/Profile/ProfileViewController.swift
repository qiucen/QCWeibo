//
//  ProfileViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `profile view controller`
class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - unfinished view
        let visitorView = VisitorView()
        visitorView.loginButton.isHidden = true
        view = visitorView
    }
    

    
}
