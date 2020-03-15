//
//  Status.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `status model`
class Status: NSObject {

    // MARK: - properties
    @objc var id: Int64 = 0
    @objc var text: String?
    @objc var created_at: String?
    @objc var source: String? {
        didSet {
            source = (source?.href()?.text != nil) ? ("来自 " + (source?.href()?.text)!) : nil
        }
    }
    @objc var pic_urls: [[String : String]]?
    @objc var user: User?
    @objc var retweeted_status: Status?
    
    // MARK: - init
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // `set value for the two properties of models`
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            if let dict = value as? [String : Any] {
                user = User(dict: dict)
            }
            return
        }
        
        if key == "retweeted_status" {
            if let dict = value as? [String : Any] {
                retweeted_status = Status(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    // `description`
    override var description: String {
        let keys = ["id", "text", "created_at", "source", "pic_urls", "user", "retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
