//
//  RefreshView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `refresh view`
class RefreshView: UIView {

    // MARK: - lazy
    lazy var tipIconView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    lazy var tipLabel = UILabel(title: "下拉开始刷新", textColor: .darkGray, fontSize: 11)
    lazy var loadingIconView = UIImageView(image: UIImage(named: "tableview_loading"))
    lazy var loadingLabel = UILabel(title: "正在刷新数据...", textColor: .darkGray, fontSize: 11)
    lazy var refreshView = UIView(
        imageView: tipIconView,
        label: tipLabel,
        frame: setFrame()
    )
    lazy var loadingView = UIView(
        imageView: loadingIconView,
        label: loadingLabel,
        frame: setFrame()
    )
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshView.backgroundColor = .white
        loadingView.addSubview(refreshView)
        addSubview(loadingView)

//        printQCDebug(message: refreshView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /// `rotate state`
    var rotateFlag = false {
        didSet {
            rotateTipIconView()
        }
    }
    
}

// MARK: - func
extension RefreshView {
    
    /// `set frame`
    private func setFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
    }
    
    /// `rotate tip icon view`
    func rotateTipIconView() {
        var angle = CGFloat.pi
        angle += rotateFlag ? -0.0000001 : 0.0000001
        UIView.animate(withDuration: 0.25) {
            self.tipIconView.transform = CGAffineTransform(
                rotationAngle: angle).concatenating(self.tipIconView.transform
            )
        }
    }
    
    /// `start animation`
    func startAnimation() {
        refreshView.isHidden = true
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            return
        }
        let animation = CABasicAnimation(keyPath: key)
        animation.toValue = 2 * CGFloat.pi
        animation.repeatCount = .infinity
        animation.duration = 1
        loadingIconView.layer.add(animation, forKey: key)
    }
    
    /// `stop animation`
    func stopAnimation() {
        refreshView.isHidden = false
        loadingIconView.layer.removeAllAnimations()
    }
    
}
