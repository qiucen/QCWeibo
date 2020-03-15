//
//  Emoticon.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `emoticon model`
class Emoticon: NSObject {

    // MARK: - properties
    @objc var chs: String?
    @objc var png: String?
    @objc var emoji: String?
    @objc var imagePath: String {
        if png == nil {
            return ""
        }
        return Bundle.main.bundlePath + "/Emoticons.bundle" + png!
    }
    @objc var code: String? {
        didSet {
            emoji = code?.emoji
        }
    }
    @objc var isRemoved = false
    @objc var isEmpty = false
    @objc var times = 0
    
    
    // MARK: - init
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        super.init()
    }
    
    init(isRemoved: Bool) {
        self.isRemoved = isRemoved
        super.init()
    }
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // MARK: - description
    override var description: String {
        let keys = ["chs", "png", "code", "isEmpty", "isRemoved"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
