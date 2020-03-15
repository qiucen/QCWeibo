//
//  UIBarButtonItem+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// convenience init
    /// - Parameters:
    ///   - imageName: image name
    ///   - target: target
    ///   - actionName: action name 
    convenience init(imageName: String, target: Any?, actionName: String?) {
        
        let button = UIButton(imageName: imageName, hilightedImage: nil, seletedImage: nil)
        if actionName != nil {
            button.addTarget(target, action: Selector(actionName ?? ""), for: .touchUpInside)
        }
        self.init(customView: button)
    }
}
