//
//  EmoticonPackage.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `emoticon package model`
class EmoticonPackage: NSObject {

    @objc var id: String?
    @objc var group_name_cn: String?
    @objc lazy var emoticons = [Emoticon]()
    
    
    init(dict: [String : Any]) {
        super.init()
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        
        if let array = dict["emoticons"] as? [[String : Any]] {
            var index = 0
            for var d in array {
                if let png = d["png"] as? String {
                    d["png"] = "/emoticonImage/" + png
                }
                emoticons.append(Emoticon(dict: d))
                index += 1
                if index == 23 {
                    emoticons.append(Emoticon(isRemoved: true))
                    index = 0
                }
            }
        }
        appendEmptyEmoticon()
    }
    
    private func appendEmptyEmoticon() {
        let count = emoticons.count % 24
        for _ in count ..< 23 {
            emoticons.append(Emoticon(isEmpty: true))
        }
    }
    
    override var description: String {
        let keys = ["id", "group_name_cn", "emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
