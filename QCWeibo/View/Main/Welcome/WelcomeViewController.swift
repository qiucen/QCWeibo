//
//  WelcomeViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SDWebImage

private let kIconViewImageWidth: CGFloat = 90

class WelcomeViewController: UIViewController {
    
    // MARK: - lazy
    private lazy var imageView = UIImageView(image: UIImage(named: "welcome"))
    private lazy var welcomeLabel = UILabel(title: "欢迎回来", textColor: .black, fontSize: 18)
    private lazy var iconView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "tabbar_video_placeholder"))
        icon.layer.cornerRadius = 45
        icon.layer.masksToBounds = true
        return icon
    }()

    // MARK: - view life circle
    override func loadView() {
        view = imageView
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // `SDWebImage loads user's avatar`
        iconView.sd_setImage(with: UserAccountViewModel.shared.avatarURL, placeholderImage: UIImage(named: "tabbar_video_placeholder"), options: [], completed: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // `update constraints`
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 500)
        }
        
        // `animation`
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1) {
                self.welcomeLabel.alpha = 1
                // `post notification`
                NotificationCenter.default.post(
                    name: NSNotification.Name(kSwitchRootViewControllerNotification),
                    object: nil
                )
            }
        }
    }
 
}


// MARK: - set UI
extension WelcomeViewController {
    
    /// `set UI`
    private func setUI() {
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.width.equalTo(kIconViewImageWidth)
            make.height.equalTo(kIconViewImageWidth)
        }
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
    }
}
