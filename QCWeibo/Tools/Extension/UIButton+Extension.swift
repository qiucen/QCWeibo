//
//  UIButton+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// convenience init
    /// - Parameters:
    ///   - title: title of the button
    ///   - fontSize: font size of the button
    ///   - titleColor: title color of the button
    ///   - imageName: image name of the button
    ///   - backgroundColor: background color of the button
    convenience init(title: String, fontSize: CGFloat, titleColor: UIColor, imageName: String?, backgroundColor: UIColor? = nil) {
        
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
        }
        
        self.backgroundColor = backgroundColor
        titleLabel?.font = .systemFont(ofSize: fontSize)
        
        sizeToFit()
        
    }
    
    /// convenience init
    /// - Parameters:
    ///   - imageName: image name of the button
    ///   - hilightedImage: hilighted Image name of the button
    ///   - seletedImage: seleted Image name of the button
    convenience init(imageName: String, hilightedImage: String?, seletedImage: String?) {
        
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        if let hilightedImage = hilightedImage {
            setImage(UIImage(named: hilightedImage), for: .highlighted)
        }
        if let seletedImage = seletedImage {
            setImage(UIImage(named: seletedImage), for: .selected)
        }
        
        sizeToFit()
    }
}
