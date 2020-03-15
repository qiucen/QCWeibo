//
//  OAuthViewController.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import SVProgressHUD

/// `OAuth view controller`
class OAuthViewController: UIViewController {
    
    // MARK: - lazy
    private lazy var webView = UIWebView()

    // MARK: - set UI
    override func loadView() {
        view = webView
        // `delegate`
        webView.delegate = self
        title = "登录新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        self.webView.loadRequest(URLRequest(url: NetworkTool.shared.oauthURL))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    
    // MARK: - #selector
    @objc private func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: false, completion: nil)
    }
 

}


// MARK: - UIWebViewDelegate
extension OAuthViewController: UIWebViewDelegate {
    
    /// `should start load request`
    /// - Parameters:
    ///   - webView: web view
    ///   - request: request
    ///   - navigationType: navigation type
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let url = request.url, url.host == "www.baidu.com" else { return true }
        guard let query = url.query, query.hasPrefix("code=") else {
            printQCDebug(message: "Cancle")
            close()
            return false
        }
        let code = query.suffix(from: "code=".endIndex)
        printQCDebug(message: "code = \(code)")
        UserAccountViewModel.shared.loadAccessToken(code: String(code)) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "you are offline!")
                delay(delta: 1) { self.close() }
                return
            }
            printQCDebug(message: "succeed")
            self.dismiss(animated: false) {
                SVProgressHUD.dismiss()
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: kSwitchRootViewControllerNotification),
                    object: "welcome"
                )
            }
            printQCDebug(message: "come here")
        }
        return false
    }
    
    /// `start load`
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    /// `finish load`
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
