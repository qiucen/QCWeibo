//
//  StatusListViewModel.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation
import SDWebImage

/// `status list view model`
class StatusListViewModel {
    
    lazy var statusList = [StatusViewModel]()
    var pulldownCount: Int?
    
    func loadStatus(isPullUp: Bool, finished: @escaping (_ isSuccess: Bool) -> ()) {
        let since_id = isPullUp ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = isPullUp ? (statusList.last?.status.id ?? 0) : 0
        StatusDAL.loadStatus(since_id: Int(since_id), max_id: Int(max_id)) { (array) in
            guard let array = array else {
                finished(false)
                return
            }
            var dataList = [StatusViewModel]()
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict: dict)))
            }
            printQCDebug(message: "刷新到 \(dataList.count) 条数据")
            self.pulldownCount = (since_id > 0) ? dataList.count : nil
            if max_id > 0 {
                self.statusList += dataList
            } else {
                self.statusList = dataList + self.statusList
            }
            self.cacheSingleImage(dataList: dataList, finished: finished)
        }
    }
    
    
    private func cacheSingleImage(dataList: [StatusViewModel], finished: @escaping (_ isSuccess: Bool) -> ()) {
        let group = DispatchGroup()
        var dataLenght = 0
        
        for vm in dataList {
            if vm.thumbnailURLs?.count != 1 {
                continue
            }
            let url = vm.thumbnailURLs![0]
            printQCDebug(message: "开始缓存图像 \(url)")
            group.enter()
            SDWebImageManager.shared.loadImage(
                with: url,
                options: [],
                progress: nil) { (image, _, _, _, _, _) in
                    if let image = image, let data: Data = UIImage.pngData(image)() {
                        dataLenght += data.count
                    }
                    group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            printQCDebug(message: "缓存完成 \(dataLenght / 1024) k")
            finished(true)
        }
        
    }
    
}
