//
//  String+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation

extension String {
    
    /// regular expression
    /// - Returns: link: string, text: string
    func href() -> (link: String, text: String)? {
        
        let pattern = "<a href=\"(.*?)\" .*?>(.*?)</a>"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        guard let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else {
            return nil
        }
        
        let str = self as NSString
        let range1 = result.range(at: 1)
        let link = str.substring(with: range1)
        let range2 = result.range(at: 2)
        let text = str.substring(with: range2)
        
        return(link, text)
        
    }
}
