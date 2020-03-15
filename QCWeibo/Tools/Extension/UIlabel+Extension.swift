//
//  UIlabel+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// convenience init of label
    /// - Parameters:
    ///   - title: title of the label
    ///   - textColor: text color of the label
    ///   - fontSize: font size of the text
    ///   - screenInset: screen Inset
    convenience init(title: String, textColor: UIColor = .gray, fontSize: CGFloat = 14, screenInset: CGFloat = 0) {
        
        self.init()
        
        text = title
        self.textColor = textColor
        font = UIFont.systemFont(ofSize: fontSize)
        
        numberOfLines = 0
        
        if screenInset == 0 {
            textAlignment = .center
        } else {
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * screenInset
            textAlignment = .left
        }
        
        sizeToFit()
    }
}
