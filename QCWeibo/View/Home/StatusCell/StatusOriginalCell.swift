//
//  StatusOriginalCell.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `original status cell`
class StatusOriginalCell: StatusTableViewCell {
    
    /// `override viewModel`
    override var viewModel: StatusViewModel? {
        didSet {
            pictureView.snp.updateConstraints { (make) in
                let offset = viewModel?.thumbnailURLs?.count ?? 0 > 0 ? kStatusCellMargin : 0
                make.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    override func setUI() {
        super.setUI()
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(kStatusCellMargin)
            make.leading.equalTo(contentLabel.snp.leading)
            make.width.equalTo(contentView.snp.width).offset(-2 * kStatusCellMargin) //(351)
            make.height.equalTo(90)
        }
    }

}
