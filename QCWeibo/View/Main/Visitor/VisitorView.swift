//
//  VisitorView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SnapKit

private let kVisitorViewLoginPictureMargin: CGFloat = 180
private let kVisitorViewUIMargin: CGFloat = 10

/// `visitor view, shows when user didn't login`
class VisitorView: UIView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lazy
    private lazy var loginPicture = UIImageView(image: UIImage(named: "login_picture"))
    private lazy var labelBig = UILabel(title: "登录微博", textColor: .black, fontSize: 18)
    private lazy var labelSmall = UILabel(title: "分享生活 发现世界", textColor: .darkGray, fontSize: 16)
    lazy var loginButton = UIButton(title: "去登录", fontSize: 16, titleColor: .orange, imageName: nil)
    

}

// MARK: - set UI
extension VisitorView {
    
    /// `set UI`
    private func setUI() {
        addSubview(loginPicture)
        addSubview(labelBig)
        addSubview(labelSmall)
        addSubview(loginButton)
        
        // `auto layout`
        loginPicture.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(kVisitorViewLoginPictureMargin)
            make.centerX.equalTo(self.snp.centerX)
        }
        labelBig.snp.makeConstraints { (make) in
            make.top.equalTo(loginPicture.snp.bottom).offset(kVisitorViewUIMargin)
            make.centerX.equalTo(loginPicture.snp.centerX)
        }
        labelSmall.snp.makeConstraints { (make) in
            make.top.equalTo(labelBig.snp.bottom).offset(kVisitorViewUIMargin)
            make.centerX.equalTo(labelBig.snp.centerX)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(labelSmall.snp.bottom).offset(kVisitorViewLoginPictureMargin)
            make.centerX.equalTo(labelSmall.snp.centerX)
        }
    }
}
