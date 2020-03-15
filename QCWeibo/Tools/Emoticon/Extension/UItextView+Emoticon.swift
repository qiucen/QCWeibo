//
//  UItextView+Emoticon.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UITextView {
    
    var emoticonText: String {
        var strM = String()
        let attrText = attributedText
        attrText?.enumerateAttributes(
            in: NSRange(location: 0, length: attrText!.length),
            options: [],
            using: { (dict, range, _) in
                if let attachment = dict[NSAttributedString.Key("NSAttachment")] as? EmoticonAttachment {
                    strM += attachment.emoticon.chs ?? ""
                } else {
                    let str = (attrText!.string as NSString).substring(with: range)
                    strM += str
                }
        })
        return strM
    }
    
    
    func insertEmoticon(em: Emoticon) {
        if em.isEmpty {
            return
        }
        if em.isRemoved {
            deleteBackward()
            return
        }
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        insertImageEmoticon(em: em)
    }
    
    /// `insert image emoticon`
    private func insertImageEmoticon(em: Emoticon) {
        let imageText = EmoticonAttachment(emoticon: em).imageText(font: font!)
        let strM = NSMutableAttributedString(attributedString: attributedText)
        strM.replaceCharacters(in: selectedRange, with: imageText)
        let range = selectedRange
        attributedText = strM
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
