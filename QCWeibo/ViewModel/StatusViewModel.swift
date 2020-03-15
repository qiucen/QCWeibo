//
//  StatusViewModel.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `status view model`
class StatusViewModel: CustomStringConvertible {
    
    // MARK: - properties
    var status: Status
    var cellId: String {
        return status.retweeted_status != nil ? kStatusRetweetedCellId : kStatusOriginalCellId
    }
    lazy var rowHeight: CGFloat = {
        var cell: StatusTableViewCell
        if self.status.retweeted_status != nil {
            cell = StatusRetweetedCell(style: .default, reuseIdentifier: kStatusRetweetedCellId)
        } else {
            cell = StatusOriginalCell(style: .default, reuseIdentifier: kStatusOriginalCellId)
        }
        return cell.calcRowHeight(vm: self)
    }()
    var create_at: String? {
        return Date.sinaDate(dateString: status.created_at ?? "")?.dateDescription
    }
    var user_profile_url: URL {
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    var user_default_icon_image: UIImage {
        return UIImage(named: "tabbar_video_placeholder")!
    }
    var user_verified_image: UIImage? {
        if status.user?.verified_type != -1 {
            for i in 0...13 {
                let images = [UIImage(named: "avatar_vip_golden_anim_\(i)")!]
                return UIImage.animatedImage(with: images, duration: .infinity)
            }
        }
        return nil
    }
    var user_mrank_image: UIImage {
//        if status.user?.mrank == 0 {
//            return UIImage(named: "common_icon_membership_expired")!
//        }
        return status.user?.mrank == 0 ? UIImage(named: "common_icon_membership_expired")! : UIImage(named: "common_icon_membership_level\(status.user!.mrank)")!
    }
    var thumbnailURLs: [URL]?
    var retweetedText: String? {
        guard let retweetedStatus = status.retweeted_status else { return nil }
        return "@" + (retweetedStatus.user?.screen_name ?? "") + (retweetedStatus.text!)
    }
    
    // MARK: - init
    init(status: Status) {
        self.status = status
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            thumbnailURLs = [URL]()
            for dict in urls {
                let url = URL(string: dict["thumbnail_pic"]!)
                thumbnailURLs?.append(url!)
            }
        }
    }
    
    // MARK: - CustomStringConvertible protocol
    var description: String {
        return status.description + "配图数组 \((thumbnailURLs ?? []) as NSArray)"
    }
    
}
