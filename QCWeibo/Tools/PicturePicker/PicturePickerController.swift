//
//  PicturePickerController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

private let kPicturePickerCellId = "kPicturePickerCellId"
private let kPicturePickerMaxCount = 9

class PicturePickerController: UICollectionViewController {

    lazy var pictures = [UIImage]()
    private var selectedIndex = 0
    
    // MARK: - init
    init() {
        super.init(collectionViewLayout: picturePickerLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: kPicturePickerCellId)
    }
    
    
    /// `picturePickerLayout`
    private class picturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let width = ((collectionView?.bounds.width)! - (count + 1) * margin) / count
            itemSize = CGSize(width: width, height: width)
            sectionInset = .init(top: margin, left: margin, bottom: 0, right: margin)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
        }
    }
    
}


// MARK: - date source
extension PicturePickerController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + (pictures.count == kPicturePickerMaxCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: kPicturePickerCellId, for: indexPath
        ) as! PicturePickerCell
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] : nil
        cell.pictureDelegate = self
        return cell
    }
}


// MARK: - PicturePickerCellDelegate
extension PicturePickerController: PicturePickerCellDelegate {
    
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            printQCDebug(message: "无法访问相册")
            return
        }
        selectedIndex = collectionView.indexPath(for: cell)?.item ?? 0
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        let indexPath = collectionView.indexPath(for: cell)!
        if indexPath.item >= pictures.count {
            return
        }
        pictures.remove(at: indexPath.item)
        collectionView.reloadData()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension PicturePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let scaleImage = image.scaleToWidth(width: 600)
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        } else {
            pictures[selectedIndex] = scaleImage
        }
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - PicturePickerCellDelegate
@objc
private protocol PicturePickerCellDelegate: NSObjectProtocol {
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
}


// MARK: - picture picker cell
private class PicturePickerCell: UICollectionViewCell {
    
    weak var pictureDelegate: PicturePickerCellDelegate?
    
    private lazy var addButton = UIButton(imageName: "compose_pic_add", hilightedImage: nil, seletedImage: nil)
    private lazy var removeButton = UIButton(imageName: "compose_photo_close", hilightedImage: nil, seletedImage: nil)
    
    var image: UIImage? {
        didSet {
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            removeButton.isHidden = (image == nil)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        addButton.frame = bounds
        removeButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
        }
        
        addButton.addTarget(self, action: #selector(addPic), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removePic), for: .touchUpInside)
        
        addButton.imageView?.contentMode = .scaleAspectFill
    }
    
    @objc private func addPic() {
        pictureDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc private func removePic() {
        pictureDelegate?.picturePickerCellDidRemove?(cell: self)
    }
}
