//
//  StatusPictureView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SDWebImage

/// `status pic cell margin`
private let kStatusPictureViewItemMargin: CGFloat = 8
/// `reuse identifier`
private let kStatusPictureCellId = "kStatusPictureCellId"

/// `picture view`
class StatusPictureView: UICollectionView {

    
    /// `status view model`
    var viewModel: StatusViewModel? {
        didSet {
            sizeToFit()
            reloadData()
        }
    }
    
    /// `size that fits`
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    // MARK: - init
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kStatusPictureViewItemMargin
        layout.minimumInteritemSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .white
        dataSource = self
        delegate = self
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: kStatusPictureCellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - data source / delegate
extension StatusPictureView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: kStatusPictureCellId,
            for: indexPath
        ) as! StatusPictureViewCell
        cell.imageURL = viewModel?.thumbnailURLs![indexPath.row]
        cell.backgroundColor = .red
        return cell
    }
    
    /// `notification`
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: NSNotification.Name(kStatusSelectedPhotoNotification),
            object: self,
            userInfo: [kStatusSelectedPhotoAtIndexPathKey : indexPath,
                       kStatusSelcetedPhotoURLsKey : viewModel!.thumbnailURLs!]
        )
    }
}


// MARK: - PhotoBrowserPresentDelegate
extension StatusPictureView: PhotoBrowserPresentDelegate {
    
    func imageViewToPresent(indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        if let url = viewModel?.thumbnailURLs?[indexPath.item] {
            imageView.sd_setImage(with: url, completed: nil)
        }
        
        return imageView
    }
    
    
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect {
        let cell = self.cellForItem(at: indexPath)!
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        return rect
    }
    
    
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect {
        guard let key = viewModel?.thumbnailURLs?[indexPath.item].absoluteString else { return .zero }
        guard let image = SDImageCache.shared.imageFromDiskCache(forKey: key) else { return .zero }
        
        let width = UIScreen.main.bounds.width
        let height = image.size.width * width / image.size.height
        
        let screenHeight = UIScreen.main.bounds.height
        var y: CGFloat = 0
        if height < screenHeight {
            y = (screenHeight - height) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: width, height: height)
        
    }
    
    
}


// MARK: - calculate
extension StatusPictureView {
    
    /// `calculating`
    private func calcViewSize() -> CGSize {
        
        // `preparation for calculating`
        let rowCount: CGFloat = 3
        let maxWidth = UIScreen.main.bounds.width - 2 * kStatusCellMargin
        let itemWidth = (maxWidth - 2 * kStatusPictureViewItemMargin) / rowCount
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let count = viewModel?.thumbnailURLs?.count ?? 0
        
        // `stastr calculating`
        // `0 pic`
        if count == 0 {
            return .zero
        }
        // `1 pic`
        if count == 1 {
            var size = CGSize(width: 150, height: 120)
            // `check from cache`
            if let key = viewModel?.thumbnailURLs?.first?.absoluteString {
                let image = SDImageCache.shared.imageFromDiskCache(forKey: key)
                size = image!.size
            }
            size.width = size.width < 40 ? 40 : size.width
            if size.width > 300 {
                let width: CGFloat = 300
                let height = size.height * width / size.height
                size = CGSize(width: width, height: height)
            }
            layout.itemSize = size
            return size
        }
        // `4 pics`
        if count == 4 {
            let width = 2 * itemWidth + kStatusPictureViewItemMargin
            return CGSize(width: width, height: width)
        }
        // `other situation`
        let row = CGFloat((count - 1) / Int(rowCount) + 1)
        let height = row * itemWidth + (row - 1) * kStatusPictureViewItemMargin
        let width = rowCount * itemWidth + (rowCount - 1) * kStatusPictureViewItemMargin
        return CGSize(width: width, height: height)
    }
    
}



// MARK: - status picture view cell
/// `status picture view cell`
private class StatusPictureViewCell: UICollectionViewCell {
    
    // MARK: - lazy
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var gifIconTipView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    
    var imageURL: URL? {
        didSet {
            iconView.sd_setImage(
                with: imageURL,
                placeholderImage: nil,
                options: [SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached],
                completed: nil
            )
            let ext = (imageURL?.absoluteString as NSString?)!.pathExtension
            gifIconTipView.isHidden = (ext != "gif")
            // TODO: - 添加长图提示标志
        }
    }
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// `set UI`
    private func setUI() {
        contentView.addSubview(iconView)
        iconView.addSubview(gifIconTipView)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
        gifIconTipView.snp.makeConstraints { (make) in
            make.trailing.equalTo(iconView.snp.trailing)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        
    }
}
