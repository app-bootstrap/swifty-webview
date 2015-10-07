//
//  Webview.swift
//  swifty-webview
//
//  Created by xdf on 9/4/15.
//  Copyright (c) 2015 open source. All rights reserved.
//

import UIKit

class Webview: UIWebView {
    
    func loadURL(urlString: String) {
        var url: NSURL;
        
        if (urlString == "TEST") {
            url = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("test", ofType:"html" , inDirectory:"static")!)
        } else {
            url = NSURL(string: urlString)!
        }
        
        print(url);

        let request = NSURLRequest(URL: url)
        
        super.loadRequest(request)
    }
}