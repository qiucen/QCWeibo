//
//  EmoticonView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

private let kEmoticonViewCellId = "kEmoticonViewCellId"

/// `emoticon view`
class EmoticonView: UIView {

    var selectedEmoticonCallBack: (_ emoticon: Emoticon) -> ()
    
    // MARK: - lazy
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: EmoticonLayout())
    private lazy var toolbar = UIToolbar(frame: UIScreen.main.bounds)
    private lazy var packages = EmoticonManager.shared.packages
    
    private class EmoticonLayout: UICollectionViewFlowLayout {
        override func prepare() {
            sectionInset = .init(top: 8, left: 0, bottom: 8, right: 0)
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
    
    init(selectedEmoticon: @escaping (_ emoticon: Emoticon) -> ()) {
        selectedEmoticonCallBack = selectedEmoticon
        var rect = UIScreen.main.bounds
        rect.size.height = 301
        super.init(frame: rect)
        backgroundColor = .white
        setUI()
        
        let indexPath = IndexPath(item: 0, section: 1)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - set UI
private extension EmoticonView {
    
    func setUI() {
        addSubview(toolbar)
        addSubview(collectionView)
        
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(toolbar.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        prepareToolbar()
        prepareColltionView()
    }
    
    func prepareToolbar() {
        toolbar.tintColor = .darkGray
        var items = [UIBarButtonItem]()
        var index = 0
        for p in packages {
            items.append(UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: #selector(selectItem(item:))))
            items.last?.tag = index
            index += 1
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
    
    @objc func selectItem(item: UIBarButtonItem) {
        let indexPath = IndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func prepareColltionView() {
        collectionView.backgroundColor = .white
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: kEmoticonViewCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}


// MARK: - data source & delegate
extension EmoticonView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let em = packages[indexPath.section].emoticons[indexPath.row]
        selectedEmoticonCallBack(em)
        if indexPath.section > 0 {
            EmoticonManager.shared.addFavorite(em: em)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: kEmoticonViewCellId,
            for: indexPath
        ) as! EmoticonViewCell
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    
    
}


// MARK: - emoticon view cell
private class EmoticonViewCell: UICollectionViewCell {
    
    lazy var emoticonButton = UIButton()
    
    var emoticon: Emoticon? {
        didSet {
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), for: .normal)
            emoticonButton.setTitle(emoticon?.emoji, for: .normal)
            if emoticon!.isRemoved {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emoticonButton)
        emoticonButton.backgroundColor = .white
        emoticonButton.frame = bounds.insetBy(dx: 4, dy: 4)
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emoticonButton.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
