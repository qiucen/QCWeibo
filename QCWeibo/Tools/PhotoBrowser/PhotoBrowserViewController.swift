//
//  PhotoBrowserViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/11.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SVProgressHUD

private let kPhotoBrowserViewCellId = "kPhotoBrowserViewCellId"

class PhotoBrowserViewController: UIViewController {
    
    // MARK: - properties
    private var urls: [URL]
    private var currentIndexPath: IndexPath
    
    // MARK: - init
    init(urls: [URL], indexPath: IndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lazy
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoBrowserViewLayout())
    private lazy var saveButton = UIButton(imageName: "feed_picture_icon_save", hilightedImage: nil, seletedImage: nil)
    
    
    /// `photo browser view layout`
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
    
    
    // MARK: - load view
    override func loadView() {
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    

    

}

// MARK: - set UI & KVO
extension PhotoBrowserViewController {
    
    private func setUI() {
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        
        collectionView.frame = view.bounds
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        
        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: kPhotoBrowserViewCellId)
        collectionView.dataSource = self
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func savePhoto() {
        let cell = collectionView.visibleCells[0] as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(imageDidFinishSaving(image:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc private func imageDidFinishSaving(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any?) {
        let message = (error == nil) ? "保存成功" : "保存失败"
        SVProgressHUD.showInfo(withStatus: message)
    }
}


// MARK: - data source
extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: kPhotoBrowserViewCellId,
            for: indexPath
        ) as! PhotoBrowserViewCell
        cell.imageURL = urls[indexPath.item]
        cell.photoDelegate = self
        return cell
    }
    
}


// MARK: - PhotoBrowserViewCellDelegate
extension PhotoBrowserViewController: PhotoBrowserViewCellDelegate {
    
    /// `tap image to dismiss`
    func photoBrowserViewCellShouldDismiss() {
        close()
    }
    
    func photoBrowserViewCellDidZoom(scale: CGFloat) {
        let isHidden = (scale < 1)
        hideControl(isHidden: isHidden)
        if isHidden {
            view.alpha = scale
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        } else {
            view.alpha = 1.0
            view.transform = .identity
        }
    }
    
    private func hideControl(isHidden: Bool) {
        saveButton.isHidden = isHidden
        collectionView.backgroundColor = isHidden ? UIColor.clear : UIColor.black
    }
    
}


// MARK: - PhotoBrowserDismissDelegate
extension PhotoBrowserViewController: PhotoBrowserDismissDelegate {
    func imageViewToDismiss() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let cell = collectionView.visibleCells[0] as! PhotoBrowserViewCell
        imageView.image = cell.imageView.image
        imageView.frame = cell.imageView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow!)
        
        return imageView
    }
    
    func indexPathToDismiss() -> IndexPath {
        return collectionView.indexPathsForVisibleItems[0]
    }
    
    
}
