//
//  ComposeViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SVProgressHUD

/// `compose view controller`
class ComposeViewController: UIViewController {

    
    // MARK: - lazy
    private lazy var toolbar = UIToolbar()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18)
        textView.alwaysBounceHorizontal = true
        textView.keyboardDismissMode = .onDrag
        textView.delegate = self
        return textView
    }()
    private lazy var placeHolderLabel = UILabel(title: "分享新鲜事...", textColor: .lightGray, fontSize: 18)
    private lazy var picturePickerController = PicturePickerController()
    private lazy var emoticonView = EmoticonView { [weak self] (emoticon) in
        self?.textView.insertEmoticon(em: emoticon)
    }
    
    // MARK: - view loads func
    override func loadView() {
        view = UIView()
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if picturePickerController.view.frame.height == 0 {
            textView.becomeFirstResponder()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardChanged(n:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
    }
    
    
    @objc private func keyboardChanged(n: Notification) {
        let rect = (n.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offset = -UIScreen.main.bounds.height + rect.origin.y
        let duration = (n.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (n.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        
        toolbar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
        }
        
        UIView.animate(withDuration: duration) {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

   

}



// MARK: - UITextViewDelegate
extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        self.placeHolderLabel.isHidden = textView.hasText
    }
    
}



// MARK: - set UI
extension ComposeViewController {
    
    func setUI() {
        view.backgroundColor = .white
        prepareNavigationBar()
        prepareToolbar()
        prepareTextView()
        preparePicturePicker()
    }
    
    @objc private func close() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendStatus() {
        let text = textView.emoticonText
        let image = picturePickerController.pictures.last
        NetworkTool.shared.shareStatus(status: text, image: image) { (result, error) in
            if error != nil {
                printQCDebug(message: "something wrong!")
                self.close()
                return
            }
            printQCDebug(message: result)
            self.close()
        }
    }
    
    private func prepareNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "取消", style: .plain, target: self, action: #selector(close)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "发布", style: .plain, target: self, action: #selector(sendStatus)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        navigationItem.titleView = titleView
        
        let titleLabel = UILabel(title: "发微博", fontSize: 17)
        let nameLabel = UILabel(
            title: UserAccountViewModel.shared.account?.screen_name ?? "",
            textColor: .lightGray,
            fontSize: 15
        )
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.top)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.bottom.equalTo(titleView.snp.bottom)
        }
        
    }
    
    @objc private func selectEmoticon() {
        textView.resignFirstResponder()
        textView.inputView = textView.inputView == nil ? emoticonView : nil
        textView.becomeFirstResponder()
    }
    
    @objc private func selectPicture() {
        textView.resignFirstResponder()
        if picturePickerController.view.frame.height > 0 {
            return
        }
        
        picturePickerController.view.snp.updateConstraints { (make) in
            make.height.equalTo(view.bounds.height * 0.6)
        }
        
        textView.snp.remakeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(picturePickerController.view.snp.top)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func prepareToolbar() {
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(44)
        }
        
        let itemSettings = [["imageName" : "compose_toolbar_picture", "actionName" : "selectPicture"],
        ["imageName" : "compose_mentionbutton_background"],
        ["imageName" : "compose_trendbutton_background"],
        ["imageName" : "compose_gifbutton_background"],
        ["imageName" : "compose_emoticonbutton_background", "actionName" : "selectEmoticon"],
        ["imageName" : "compose_toolbar_more"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
            items.append(UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["actionName"]))
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
    
    private func prepareTextView() {
        view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(toolbar.snp.top)
        }
        
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.top).offset(8)
            make.leading.equalTo(textView.snp.leading).offset(5)
        }
    }
    
    private func preparePicturePicker() {
        addChild(picturePickerController)
        view.insertSubview(picturePickerController.view, belowSubview: toolbar)
        picturePickerController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(0)
        }
    }
    
}
