//
//  RefreshControl.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/9.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

private let kRefreshControlOffset: CGFloat = -44

/// `refresh control`
class RefreshControl: UIRefreshControl {
    
    // MARK: - lazy
    private lazy var  refreshView = RefreshView()
    
    
    // MARK: - init
    override init() {
        super.init()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    
    
    // MARK: - deinit
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
}

// MARK: - func
extension RefreshControl {
    
    /// `set UI`
    private func setUI() {
        tintColor = .clear
        addSubview(refreshView)
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(self.snp.size)
        }
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopAnimation()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        if frame.origin.y < kRefreshControlOffset && !refreshView.rotateFlag {
            refreshView.rotateFlag = true
        } else if frame.origin.y >= kRefreshControlOffset && refreshView.rotateFlag {
            refreshView.rotateFlag = false
        }
    }
    
}
