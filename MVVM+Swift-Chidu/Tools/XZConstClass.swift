//
//  XZConstClass.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/21.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class XZConstClass: NSObject {
    
    let EMPTY_STRING = ""
    
    let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    let SCREEN_WIDTH = UIScreen.main.bounds.width
    
    let kConnectHost = "ws://192.168.10.12:8282"   // URL + 端口号
    
    let kImageHost = "http://192.168.10.12/tp5/"
    
    let mine_userID: Double = 12271
    
    func convertDictionaryToString(dict:[String:AnyObject]) -> String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func convertArrayToString(arr:[AnyObject]) -> String {
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    /**
     * 计算字符串长度
     */
    func sizeWithText(text: NSString, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [kCTFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return rect;
    }

}
