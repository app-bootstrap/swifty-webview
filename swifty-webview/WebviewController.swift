//
//  WebviewController.swift
//  swifty-webview
//
//  Created by xdf on 9/28/15.
//  Copyright © 2015 ddq. All rights reserved.
//

import UIKit

class WebviewController: UITabBarController, UIWebViewDelegate {
    
    var _urlString: String
    var _title: String
    var _webview = Webview()
    
    init(urlString: String, title: String, autoLoad: Bool) {
        self._urlString = urlString
        self._title = title
        super.init(nibName:nil, bundle:nil)
        
        if (autoLoad) {
            self.startLoad()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._setTitle(self._title)
        self.initView()
    }

    internal func startLoad() {
        self._webview.loadURL(self._urlString)
    }
    
    func initView() {
        //let rect:CGRect = self.view.frame
        self._webview.frame = CGRectMake(0, 65, self.view.bounds.width, self.view.bounds.height - 65 - 50)
        self._webview.scalesPageToFit = true
        self.view.addSubview(self._webview)
        self._webview.delegate = self
        self._webview.scrollView.bounces = false
    }
    
    func _setTitle(title: String) {
        self.navigationItem.title = title
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //print("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //print("webViewDidFinishLoad")
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("JSBridge", ofType:"js", inDirectory:"static")!)
        do {
            let javascript = try String(contentsOfURL: fileURL, encoding: NSUTF8StringEncoding)
            self._webview.stringByEvaluatingJavaScriptFromString(javascript)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.mainDocumentURL
        let scheme = request.URL?.scheme
        
        let host = url?.host
        let query = url?.query
        
        
        if (scheme == "jsbridge") {
            
            if (host == "call") {
                
                var queryStrings = Utils.parseQuery(query!)
                
                let method = queryStrings["method"]
                
                if (method == "setTitle") {
                    let title = Utils.getValueFromQueue(queryStrings, key: "title")
                    self._setTitle(title)
                } else if (method == "pushView") {
                    let url = Utils.getValueFromQueue(queryStrings, key: "url")
                    let title = Utils.getValueFromQueue(queryStrings, key: "title")
                    
                    if (!url.isEmpty) {
                        self.navigationController?.pushViewController(WebviewController(urlString: url, title: title, autoLoad: true), animated: true)
                    }
                } else if (method == "popView") {
                    self.navigationController?.popViewControllerAnimated(true)
                } else if (method == "login") {
                    // 1. delete session
                    // 2. redirect to login
                }
            } else if (host == "dispatch") {
                
            } else {
                
            }
            return false
        } else {
            return true
        }
    }
}
