//
//  LoginViewModel.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/15.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
    
   @objc dynamic var model = LoginModel()
    
   @objc dynamic var phoneNumber: String?
   @objc dynamic var password:String?
    
    override init() {
        super.init()
        
    }

}

class LoginModel: NSObject {
    
    public var phoneNumber: String?
    
    public var password:    String?
    
    override init() {
        super.init()
        
        phoneNumber = ""
        
        password = ""
    }
    
}
