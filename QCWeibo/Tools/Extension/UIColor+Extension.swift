//
//  UIColor+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// generating random color
    class func randomColor() -> UIColor {
        let red = CGFloat(arc4random() % 256 / 255)
        let green = CGFloat(arc4random() % 256 / 255)
        let blue = CGFloat(arc4random() % 256 / 255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
