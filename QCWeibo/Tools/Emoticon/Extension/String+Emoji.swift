//
//  String+Emoji.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation

extension String {
    
    /// `emoji of the given string`
    var emoji: String {
        let scanner = Scanner(string: self)
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        let character = Character(UnicodeScalar(value)!)
        return "\(character)"
    }
}
