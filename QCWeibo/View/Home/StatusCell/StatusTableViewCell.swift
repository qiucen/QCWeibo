//
//  StatusTableViewCell.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

let kStatusCellMargin: CGFloat = 12
/// `width and height both`
let kStatusCellIconWidth: CGFloat = 35


/// `status cell`
class StatusTableViewCell: UITableViewCell {
    
    /// `status view model`
    var viewModel: StatusViewModel? {
        didSet {
            topView.viewModel = viewModel
            let text = viewModel?.status.text ?? ""
            contentLabel.attributedText = EmoticonManager.shared.emoticonText(string: text, font: contentLabel.font)
            pictureView.viewModel = viewModel
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(pictureView.bounds.height)
                
                // MARK: - something wrong with SnapKit, this line makes crash
//                make.width.equalTo(pictureView.bounds.width)
            }
        }
    }
    
    
    /// `to calculate row height for given status view model`
    /// - Parameter vm: status view model
    /// - returns: maxY
    func calcRowHeight(vm: StatusViewModel) -> CGFloat {
        viewModel = vm
        contentView.layoutIfNeeded()
        return bottomView.frame.maxY
    }
    
    
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lazy
    private lazy var topView = StatusCellTopView()
    lazy var contentLabel = UILabel(
        title: "微博正文",
        textColor: .darkGray,
        fontSize: 15,
        screenInset: kStatusCellMargin
    )
    lazy var pictureView = StatusPictureView()
    lazy var bottomView = StatusCellBottomView()
    
}


// MARK: - set UI
extension StatusTableViewCell {
    
    @objc func setUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // `auto layout`
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(2 * kStatusCellMargin + kStatusCellIconWidth)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(kStatusCellMargin)
            make.leading.equalTo(contentView.snp.leading).offset(kStatusCellMargin)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(kStatusCellMargin)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(44)
        }
    }
}
