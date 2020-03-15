//
//  VisitorTableViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `visitor TableViewController`
class VisitorTableViewController: UITableViewController {
    
    private var userLogin = UserAccountViewModel.shared.userLogin
    var visitorView: VisitorView?

    override func loadView() {
        userLogin ? super.loadView() : setVisitorView()
    }
    
    private func setVisitorView() {
        visitorView = VisitorView()
        view = visitorView
        visitorView?.loginButton.addTarget(self, action: #selector(visitorViewDidLogin), for: .touchUpInside)
    }

    
    
    

}

// MARK:- #selector
extension VisitorTableViewController {
    
    @objc private func visitorViewDidLogin() {
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}
