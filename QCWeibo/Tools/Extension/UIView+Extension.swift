//
//  UIView+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    /// `convenience init for a view contains imageView and Label like REFRESH-VIEW`
    /// - Parameters:
    ///   - imageView: image view
    ///   - label: label
    ///   - frame:  specified frame
    convenience init(imageView: UIImageView, label: UILabel, frame: CGRect) {
        self.init()
        self.frame = frame
        addSubview(imageView)
        addSubview(label)
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(
                (UIScreen.main.bounds.width - imageView.frame.width - label.frame.width) / 2
            )
            make.centerY.equalTo(self.snp.centerY)
        }
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        sizeToFit()
    }
}
