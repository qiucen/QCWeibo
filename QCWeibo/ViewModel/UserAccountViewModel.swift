//
//  UserAccountViewModel.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation

/// `user account view model`
class UserAccountViewModel {
    
    // MARK: - singleton
    static let shared = UserAccountViewModel()
    
    
    // MARK: - properties
    var account: UserAccount?
    var accessToken: String? {
        if isExpired {
            return nil
        } else {
            return account?.access_token
        }
    }
    var userLogin: Bool {
        return account?.access_token != nil && !isExpired
    }
    var avatarURL: URL {
        return URL(string: account?.avatar_large ?? "")!
    }
    
    // MARK: - private properties
    private var accountPath: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("account.plist")
    }
    private var isExpired: Bool {
        if account?.expiresDate?.compare(Date()) == ComparisonResult.orderedDescending {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - private init
    private init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        if isExpired {
            printQCDebug(message: "opps! account is expired!")
            account = nil
        }
    }
    
}

// MARK: - network related
extension UserAccountViewModel {
    
    /// `load access token`
    /// - Parameters:
    ///   - code: access token
    ///   - finished: call back
    func loadAccessToken(code: String, finished: @escaping (_ isSuccess: Bool) -> ()) {
        NetworkTool.shared.loadAccessToken(code: code) { (result, error) in
            if error != nil {
                printQCDebug(message: "ERROR!")
                finished(false)
                return
            } else {
                self.account = UserAccount(dict: result as! [String : Any])
                self.loadUserInfo(account: self.account!, finished: finished)
            }
        }
    }
    
    /// `load user info`
    /// - Parameters:
    ///   - account: user account
    ///   - finished: call back
    func loadUserInfo(account: UserAccount, finished: @escaping (_ isSuccess: Bool) -> ()) {
        NetworkTool.shared.loadUserInfo(uid: account.uid!) { (result, error) in
            if error != nil {
                printQCDebug(message: "bad access!")
                finished(false)
                return
            }
            
            guard let dict = result as? [String : Any] else {
                printQCDebug(message: "Invalid format!")
                finished(false)
                return
            }
            
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
            
            // `save user account`
            NSKeyedArchiver.archiveRootObject(account, toFile: self.accountPath)
            printQCDebug(message: self.accountPath)
            
            finished(true)
        }
    }
}
