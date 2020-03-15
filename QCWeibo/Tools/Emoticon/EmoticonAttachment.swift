//
//  EmoticonAttachment.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `emoticon attachment`
class EmoticonAttachment: NSTextAttachment {
    
    /// `emoticon model`
    var emoticon: Emoticon
    
    func imageText(font: UIFont) -> NSAttributedString {
        image = UIImage(contentsOfFile: emoticon.imagePath)
        let lineHeight = font.lineHeight
        bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        imageText.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: 1))
        return imageText
    }
    
    init(emoticon: Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
