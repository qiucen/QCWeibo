//
//  Common.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

// MARK: - notification keys
let kSwitchRootViewControllerNotification = "kSwitchRootViewControllerNotification"
let kStatusSelectedPhotoNotification = "kStatusSelectedPhotoNotification"
let kStatusSelectedPhotoAtIndexPathKey = "kStatusSelectedPhotoAtIndexPathKey"
let kStatusSelcetedPhotoURLsKey = "kStatusSelcetedPhotoURLsKey"



// MARK: - appearance tint color
/// `appearance tint color`
let KAppearanceTintColor = UIColor.orange


// MARK: - delay func
/// `delay`
/// - Parameters:
///   - delta: seconds
///   - callFunc: call func
func delay(delta: Double, callFunc: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delta) { callFunc() }
}

// MARK: - DebugPrint
func printQCDebug<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
