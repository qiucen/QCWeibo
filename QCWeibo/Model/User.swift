//
//  User.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `user model`
class User: NSObject {

    // MARK: - properties
    @objc var id: Int = 0
    @objc var screen_name: String?
    @objc var profile_image_url: String?
    @objc var verified_type: Int = 0
    /// 0 ~ 7
    @objc var mrank: Int = 0
    
    // MARK: - init
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    // `for undefined key`
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // `description`
    override var description: String {
        let keys = ["id", "screen_name", "profile_image_url", "verified_type", "mbrank"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    
}
