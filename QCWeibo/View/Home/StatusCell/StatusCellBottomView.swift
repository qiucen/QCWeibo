//
//  StatusCellBottomView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `status cell bottom view`
class StatusCellBottomView: UIView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lazy
    private lazy var retweetedButton = UIButton(
        title: "转发",
        fontSize: 12,
        titleColor: .darkGray,
        imageName: "commentlist_icon_retweet"
    )
    private lazy var commentButton = UIButton(
        title: "评论",
        fontSize: 12,
        titleColor: .darkGray,
        imageName: "commentlist_icon_comment"
    )
    private lazy var likeButton = UIButton(
        title: "赞",
        fontSize: 12,
        titleColor: .darkGray,
        imageName: "commentlist_icon_unlike"
    )
    
}

// MARK: - set UI
extension StatusCellBottomView {
    
    private func setUI() {
        
        addSubview(retweetedButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        // `auto layout`
        retweetedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton.snp.top)
            make.leading.equalTo(retweetedButton.snp.trailing)
            make.width.equalTo(retweetedButton.snp.width)
            make.height.equalTo(retweetedButton.snp.height)
        }
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton.snp.top)
            make.leading.equalTo(commentButton.snp.trailing)
            make.width.equalTo(commentButton.snp.width)
            make.height.equalTo(commentButton.snp.height)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        // `separator view among three buttons`
        let sep1 = separator()
        let sep2 = separator()
        addSubview(sep1)
        addSubview(sep2)
        
        // 'layout'
        let width = 0.5
        let scale = 0.4
        
        sep1.snp.makeConstraints { (make) in
            make.leading.equalTo(retweetedButton.snp.trailing)
            make.centerY.equalTo(retweetedButton.snp.centerY)
            make.width.equalTo(width)
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
        }
        sep2.snp.makeConstraints { (make) in
            make.leading.equalTo(commentButton.snp.trailing)
            make.centerY.equalTo(commentButton.snp.centerY)
            make.width.equalTo(width)
            make.height.equalTo(commentButton.snp.height).multipliedBy(scale)
        }
        
        
    }
    
    /// `separator view among three buttons`
    private func separator() -> UIView {
        let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }
    
}
