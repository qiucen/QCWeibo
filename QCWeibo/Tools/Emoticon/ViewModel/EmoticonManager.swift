//
//  EmoticonManager.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `emoticon manager`
class EmoticonManager {

    /// `singleton`
    static let shared = EmoticonManager()
    /// `package model`
    lazy var packages = [EmoticonPackage]()
    
    
    // MARK: - init
    private init() {
        packages.append(EmoticonPackage(dict: ["group_name_cn" : "最近"]))
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path) as! [String : Any]
        let array = (dict["packages"] as! NSArray).value(forKey: "id")
        for id in array as! [String] {
            loadInfoPlist(id: id)
        }
    }
    
    private func loadInfoPlist(id: String) {
        let path = Bundle.main.path(forResource: "content.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        let dict = NSDictionary(contentsOfFile: path) as! [String : Any]
        packages.append(EmoticonPackage(dict: dict))
    }
    
    
    // MARK: - func
    func emoticonText(string: String, font: UIFont) -> NSAttributedString {
        let strM = NSMutableAttributedString(string: string)
        let pattern = "\\[.*?\\]"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        var count = results.count
        while count > 0 {
            count -= 1
            let range = results[count].range(at: 0)
            let emStr = (string as NSString).substring(with: range)
            if let em = emoticonWithString(string: emStr) {
                let attrText = EmoticonAttachment(emoticon: em).imageText(font: font)
                strM.replaceCharacters(in: range, with: attrText)
            }
        }
        return strM
    }
    
    private func emoticonWithString(string: String) -> Emoticon? {
        for package in packages {
            if let emoticon = package.emoticons.filter({ $0.chs == string }).last {
                return emoticon
            }
        }
        return nil
    }
    
    func addFavorite(em: Emoticon) {
        em.times += 1
        if !packages[0].emoticons.contains(em) {
            if em.isRemoved == false {
                packages[0].emoticons.insert(em, at: 0)
                packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
            }
        }
        packages[0].emoticons.sort { $0.times > $1.times }
    }
}
