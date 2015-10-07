//
//  Utils.swift
//  swifty-webview
//
//  Created by xdf on 9/4/15.
//  Copyright (c) 2015 open source. All rights reserved.
//

import UIKit
import SwiftyJSON

class Utils: NSObject {

    class func getImgView(ImgName: NSString) -> UIImage {
        
        var image:UIImage = UIImage(named: ImgName as String)!
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        return image;
    }

    class func parseQuery(querystring: String) -> [String: String] {
    
        var query = [String: String]()
        
        for qs in querystring.componentsSeparatedByString("&") {
            let key = qs.componentsSeparatedByString("=")[0]
            var value = qs.componentsSeparatedByString("=")[1]
            value = value.stringByReplacingOccurrencesOfString("+", withString: " ")
            value = value.stringByRemovingPercentEncoding!
            query[key] = value
        }
        return query
    }

    class func getValueFromQueue(queryStrings: [String: String], key: String) -> String {
        let data = String(queryStrings["data"]!)
        let dataString = data.stringByRemovingPercentEncoding!
        let _dataString = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let json = JSON(data: _dataString!)
        let value = String(json[key])
        return value
    }
    
    class func getData(key: String) -> String {
        let temp = NSUserDefaults.standardUserDefaults()
        let value = temp.objectForKey(key)

        if (value != nil) {
            return String(value)
        } else {
            return "nil"
        }
    }
    
    class func hasData(key: String) -> Bool {
        let temp = self.getData(key)
        return temp != "nil"
    }
    
    class func setData(key: String, value: String) {
        let temp = NSUserDefaults.standardUserDefaults()
        temp.setObject(value, forKey: key)
        temp.synchronize()
    }
    
    class func removeData(key: String) {
        let temp = NSUserDefaults.standardUserDefaults()
        temp.removeObjectForKey(key)
        temp.synchronize()
    }

}