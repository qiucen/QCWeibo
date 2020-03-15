//
//  Date+Extension.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation

extension Date {
    
    /// convert the sina-formatted string into a date
    /// - Parameter dateString: sina-formatted date string,
    static func sinaDate(dateString: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        return dateFormatter.date(from: dateString)
        
    }
    
    
    /// date description
    var dateDescription: String {
        
        let calendar = Calendar.current
        
        // `processing the date of today`
        if calendar.isDateInToday(self) {
            let delta = Int(Date().timeIntervalSince(self))
            
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        // `processing other date`
        var formatter = " HH:mm"
        if calendar.isDateInYesterday(self) {
            formatter = "昨天" + formatter
        } else {
            formatter = "MM-dd" + formatter
            let component = calendar.component(.year, from: self)
            if component != Calendar.current.component(.year, from: self) {
                formatter = "yyyy-" + formatter
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
}
