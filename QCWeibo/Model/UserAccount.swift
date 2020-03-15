//
//  UserAccount.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `user account model`
class UserAccount: NSObject, NSCoding {
    
    // MARK: - properties
    @objc var access_token: String?
    @objc var uid: String?
    @objc var expiresDate: Date?
    @objc var screen_name: String?
    @objc var avatar_large: String?
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    // MARK: - init
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    // `for undefined key`
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // `description`
    override var description: String {
        let keys = ["access_token", "expires_in", "uid", "expiresDate", "screen_name", "avatar_large" ]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    
    // MARK: - encode & decode
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(uid, forKey: "uid")
        coder.encode(expiresDate, forKey: "expiresDate")
        coder.encode(screen_name, forKey: "screen_name")
        coder.encode(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder: NSCoder) {
        access_token = coder.decodeObject(forKey: "access_token") as? String
        uid = coder.decodeObject(forKey: "uid") as? String
        expiresDate = coder.decodeObject(forKey: "expiresDate") as? Date
        screen_name = coder.decodeObject(forKey: "screen_name") as? String
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String
    }
    

}
