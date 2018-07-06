//
//  XZChangeColorViewModel.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/14.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class XZChangeColorViewModel: NSObject {
    
    var model = XZChangeColorModel()
    
    
    
    @objc dynamic var color:UIColor?
    
    override init() {
        super.init()
        
        model.reactive.producer(forKeyPath: "color").startWithValues { (value) in
            
            if self.model.colorName == "yellow" {
                self.color = UIColor.yellow
            }
            else{
                self.color = self.model.color
            }
        }
    }
    
    public func getColorData(){
        
        model.requestData()
    }
    
    deinit {
        // Nothing to do
    }
}

class XZChangeColorModel: NSObject {
    
    var colorName: String?
    @objc dynamic var color: UIColor?
    
    //提供一个获取数据的接口供ViewModel调用
    func requestData() {
        //生成随机色
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let colorRun = UIColor.init(red:red, green:green, blue:blue , alpha: 1)
        colorName = String(describing: red)
        color = colorRun
    }
    
}
