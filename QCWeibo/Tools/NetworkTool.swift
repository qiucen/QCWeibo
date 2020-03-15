//
//  NetworkTools.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/7.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit
import Alamofire

/// `NetworkTools`
class NetworkTool {
    
    // MARK: - APP Info
    #warning("please use your own APP info, it's esay to get from open.weibo.com")
    private let appKey = "978418750"
    private let appSecret = "6ab6635f59f47678651eff946ae05400"
    private let redirectURL = "https://www.baidu.com"
    
    // MARK: - call back
    typealias QCRequestCallBack = (_ result: Any?, _ error: NSError?) -> ()
    
    
    // MARK: - singleton
    static let shared = NetworkTool()
}


// MARK: - share to Weibo
extension NetworkTool {
    
    /// `share status to Weibo APP`
    /// - Parameters:
    ///   - status: text
    ///   - image: image
    ///   - finished: QCRequestCallBack
    ///   - see: [https://open.weibo.com/wiki/2/statuses/share](https://open.weibo.com/wiki/2/statuses/share)
    func shareStatus(status: String, image: UIImage? , finished: @escaping QCRequestCallBack) {
        
        var params = [String : Any]()
        
        params["status"] = status + "http://www.baidu.com/123"
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        if image == nil {
            tokenRequest(method: .post, URLString: urlString, parameters: params, finished: finished)
        } else {
            let data = image?.pngData()
            upload(URLString: urlString, data: data!, name: "pic", parameters: params, finished: finished)
        }
        
    }
    
}


// MARK: - status related
extension NetworkTool {
    
    /// `load status`
    /// - Parameters:
    ///   - since_id: Int
    ///   - max_id: Int
    ///   - finished: QCRequestCallBack
    /// - see: [https://open.weibo.com/wiki/2/statuses/home_timeline](https://open.weibo.com/wiki/2/statuses/home_timeline)
    func loadStatus(since_id: Int, max_id: Int, finished: @escaping QCRequestCallBack) {
        var params = [String : Any]()
        
        if since_id > 0 {
            params["since_id"] = since_id
        } else if max_id > 0 {
            params["max_id"] = max_id
        }
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        tokenRequest(method: .get, URLString: urlString, parameters: params, finished: finished)
    }
    
}

// MARK: - user account related
extension NetworkTool {
    
    /// `load user info`
    /// - Parameters:
    ///   - uid: uid
    ///   - finished: call back
    ///   - see: [https://open.weibo.com/wiki/2/users/show](https://open.weibo.com/wiki/2/users/show)
    func loadUserInfo(uid: String, finished: @escaping QCRequestCallBack) {
        var params = [String : Any]()
        let urlString = "https://api.weibo.com/2/users/show.json"
        params ["uid" ] = uid
        tokenRequest(method: .get, URLString: urlString, parameters: params, finished: finished)
    }
}


// MARK: - OAuth
extension NetworkTool {
    
    /// `OAuth URL`
    /// - see: [https://open.weibo.com/wiki/Oauth2/authorize](https://open.weibo.com/wiki/Oauth2/authorize)
    var oauthURL: URL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectURL)"
        return URL(string: urlString)!
    }
    
    /// `load access token`
    /// - Parameter code: access token
    /// - see: [https://open.weibo.com/wiki/Oauth2/access_token](https://open.weibo.com/wiki/Oauth2/access_token)
    func loadAccessToken(code: String, finished: @escaping QCRequestCallBack) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id" : appKey,
                                  "client_secret" : appSecret,
                                  "grant_type" : "authorization_code",
                                  "code" : code,
                                  "redirect_uri" : redirectURL]
        // `post request`
        request(method: .post, URLString: urlString, parameters: params, finished: finished)
        
    }
}

// MARK: - network
extension NetworkTool {
    
    /// `token request`
    /// - Parameters:
    ///   - method: GET / POST
    ///   - URLString: URLString
    ///   - parameters: parameters dictionary
    ///   - finished: callback
    private func tokenRequest(method: Alamofire.HTTPMethod, URLString: String, parameters: [String : Any]?, finished: @escaping QCRequestCallBack) {
        
        guard let token = UserAccountViewModel.shared.accessToken else {
            finished(
                QCRequestCallBack.self,
                NSError(domain: "ERROR!", code: -1, userInfo: ["message" : "token cannot be nil!"])
            )
            return
        }
        var params = [String : Any]()
        params = parameters!
        params["access_token"] = token
        request(method: method, URLString: URLString, parameters: params, finished: finished)
    }
    
    
    /// `request`
    /// - Parameters:
    ///   - method: GET / POST
    ///   - URLString: URLString
    ///   - parameters: parameters dictionary
    ///   - finished: call back
    private func request(method: Alamofire.HTTPMethod, URLString: String, parameters: [String : Any]?, finished: @escaping QCRequestCallBack) {
        
        // shows NetworkActivityIndicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // request
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            if response.result.isFailure {
                printQCDebug(message: "ERROR! \((response.result.error).debugDescription)")
            }
            
            // call back
            finished(response.result.value, response.result.error as NSError?)
        }
    }
    
    
    private func upload(
        URLString: String,
        data: Data,
        name: String,
        parameters: [String : Any]?,
        finished: @escaping QCRequestCallBack
    ) {
        guard let token = UserAccountViewModel.shared.accessToken else {
            finished(
                QCRequestCallBack.self,
                NSError(domain: "ERROR!", code: -1, userInfo: ["message" : "token cannot be nil!"])
            )
            return
        }
        
        var params = [String : Any]()
        params = parameters!
        params["access_token"] = token
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // `upload multipart form data`
        Alamofire.upload(multipartFormData: { (formData) in
            
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            formData.append(data, withName: name, fileName: "", mimeType: "application/octet-stream")
            
            for (k, v) in params {
                let str = v as! String
                let strData = str.data(using: .utf8)!
                formData.append(strData, withName: k)
            }
            
        }, usingThreshold: 5 * 1024 * 1024,
           to: URLString,
           method: .post) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(request: let upload, _, _):
                upload.responseJSON { (response) in
                    
                    if response.result.isFailure {
                        printQCDebug(message: "网络请求失败 \(String(describing: response.result.error))")
                    }
                    finished(response.result.value, response.result.error as NSError?)
                }
                
            case .failure(let error):
                printQCDebug(message: "上传文件编码错误 \(error)")
            }
        }
        
    }
    
    
}
