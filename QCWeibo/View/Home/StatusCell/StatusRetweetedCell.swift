//
//  StatusRetweetedCell.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `retweeted status cell`
class StatusRetweetedCell: StatusTableViewCell {

    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return button
    }()
    
    private lazy var retweetedLabel = UILabel(
        title: "转发微博",
        textColor: .darkGray,
        fontSize: 14,
        screenInset: kStatusCellMargin
    )
    
    override var viewModel: StatusViewModel? {
        didSet {
            let text = viewModel?.retweetedText ?? ""
            retweetedLabel.attributedText = EmoticonManager.shared.emoticonText(
                string: text,
                font: retweetedLabel.font
            )
            pictureView.snp.updateConstraints { (make) in
                let offset = viewModel?.thumbnailURLs?.count ?? 0 > 0 ? kStatusCellMargin : 0
                make.top.equalTo(retweetedLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    override func setUI() {
        super.setUI()
        contentView.insertSubview(backgroundButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backgroundButton)
        
        backgroundButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(kStatusCellMargin)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundButton.snp.top).offset(kStatusCellMargin)
            make.leading.equalTo(backgroundButton.snp.leading).offset(kStatusCellMargin)
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(kStatusCellMargin)
            make.leading.equalTo(retweetedLabel.snp.leading)
            make.width.equalTo(contentView.snp.width).offset(-2 * kStatusCellMargin)
            make.height.equalTo(90)
        }
    }

}
