//
//  PhotoBrowserViewCell.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/11.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

// MARK: - protocol
protocol PhotoBrowserViewCellDelegate: NSObject {
    func photoBrowserViewCellShouldDismiss()
    func photoBrowserViewCellDidZoom(scale: CGFloat)
}


/// `photo vrowser view cell`
class PhotoBrowserViewCell: UICollectionViewCell {
    
    weak var photoDelegate: PhotoBrowserViewCellDelegate?
    
    // MARK: - lazy
    lazy var scrollView = UIScrollView()
    lazy var imageView = UIImageView()
    private lazy var placeHolder = PhotoProgressView()
    
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else { return }
            resetScrollView()
            let placeHolder = SDImageCache.shared.imageFromDiskCache(forKey: url.absoluteString)
            setPlaceHolder(image: placeHolder)
            imageView.sd_setImage(
                with: bmiddleURL(url: url),
                placeholderImage: nil,
                options: [SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached],
                progress: { (current, total, _) in
                    DispatchQueue.main.async {
                        self.placeHolder.progress = CGFloat(current) / CGFloat(total)
                    }
            }) { (image, _, _, _) in
                if image == nil {
                    SVProgressHUD.showInfo(withStatus: "您的网络不给力")
                    return
                }
                self.placeHolder.isHidden = true
                self.setPosition(image: image!)
            }
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
    
    private func setUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeHolder)
        
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        scrollView.delegate = self as UIScrollViewDelegate
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func tapToDismiss() {
        photoDelegate?.photoBrowserViewCellShouldDismiss()
    }
    
    
    // MARK: - func
    
    /// `set place holder image`
    /// - Parameter image: image from disk cache
    private func setPlaceHolder(image: UIImage?) {
        placeHolder.image = image
        placeHolder.isHidden = false
        placeHolder.sizeToFit()
        placeHolder.center = scrollView.center
    }
    
    /// `reset scroll view`
    private func resetScrollView() {
        imageView.transform = CGAffineTransform.identity
        scrollView.contentSize = .zero
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
    }
    
    /// `set position`
    private func setPosition(image: UIImage) {
        let size = self.calcDisplaySize(image: image)
        if size.height < scrollView.bounds.height {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }
    
    /// `calculate size`
    private func calcDisplaySize(image: UIImage) -> CGSize {
        let width = scrollView.bounds.width
        let height = image.size.height * width / image.size.width
        return CGSize(width: width, height: height)
    }
    
    private func bmiddleURL(url: URL) -> URL {
        var urlstr = url.absoluteString as NSString
        urlstr = urlstr.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/") as NSString
        return URL(string: urlstr as String)!
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension PhotoBrowserViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale < 1 {
            photoDelegate?.photoBrowserViewCellShouldDismiss()
            return
        }
        var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        photoDelegate?.photoBrowserViewCellDidZoom(scale: imageView.transform.a)
    }
}
