//
//  StatusCellTopView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `status cell top view`
class StatusCellTopView: UIView {

    
    /// `status view model`
    var viewModel: StatusViewModel? {
        didSet {
            iconVIew.sd_setImage(
                with: viewModel?.user_profile_url,
                placeholderImage: viewModel?.user_default_icon_image,
                options: [],
                completed: nil
            )
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.user_mrank_image
            verifiedIconView.image = viewModel?.user_verified_image
            timeLabel.text = viewModel?.create_at
            sourceLabel.text = viewModel?.status.source
        }
    }
    
    // MARK: - lazy
    private lazy var iconVIew = UIImageView(image: UIImage(named: "tabbar_video_placeholder"))
    private lazy var nameLabel = UILabel(title: "placeholder", fontSize: 14)
    private lazy var memberIconView = UIImageView(image: UIImage(named: "common_icon_membership_expired"))
    private lazy var verifiedIconView = UIImageView(image: UIImage(named: "avatar_vip_golden"))
    private lazy var timeLabel = UILabel(title: "now", textColor: .orange, fontSize: 11)
    private lazy var sourceLabel = UILabel(title: "from", textColor: .orange, fontSize: 11)
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - set UI
extension StatusCellTopView {
    
    /// `set UI`
    private func setUI() {
        backgroundColor = .white
        // `separator, a small white view`
        let separator = UIView()
        separator.backgroundColor = .white
        addSubview(separator)
        
        addSubview(iconVIew)
        addSubview(nameLabel)
        addSubview(memberIconView)
        addSubview(verifiedIconView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // `auto layout`
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(kStatusCellMargin)
        }
        iconVIew.snp.makeConstraints { (make) in
            make.top.equalTo(separator.snp.bottom).offset(kStatusCellMargin)
            make.leading.equalTo(self.snp.leading).offset(kStatusCellMargin)
            make.width.equalTo(kStatusCellIconWidth)
            make.height.equalTo(kStatusCellIconWidth)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconVIew.snp.top)
            make.leading.equalTo(iconVIew.snp.trailing).offset(kStatusCellMargin)
        }
        memberIconView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.top)
            make.leading.equalTo(nameLabel.snp.trailing)
            make.width.equalTo(kStatusCellMargin)
            make.height.equalTo(kStatusCellMargin)
        }
        verifiedIconView.snp.makeConstraints { (make) in
            make.width.equalTo(kStatusCellMargin)
            make.height.equalTo(kStatusCellMargin)
            make.centerX.equalTo(iconVIew.snp.trailing)
            make.centerY.equalTo(iconVIew.snp.bottom)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconVIew.snp.bottom)
            make.leading.equalTo(iconVIew.snp.trailing).offset(kStatusCellMargin)
        }
        sourceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(timeLabel.snp.bottom)
            make.leading.equalTo(timeLabel.snp.trailing).offset(kStatusCellMargin)
        }
        
    }
}
