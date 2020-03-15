//
//  PhotoProgressView.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// `shows when downloading image from network`
class PhotoProgressView: UIImageView {

    var progress: CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    private lazy var progressView = ProgressView()
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(progressView)
        progressView.backgroundColor = .clear
        progressView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
}

/// `progress view`
private class ProgressView: UIView {
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = min(rect.width, rect.height) * 0.5
        let start = CGFloat.pi * -0.5
        let end = start + progress * 2 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        path.addLine(to: center)
        path.close()
        UIColor(white: 1.0, alpha: 0.3).setFill()
        path.fill()
    }
}
