//
//  XZBaseView.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/27.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class XZBaseView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor() {
        
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
}

class XZBaseButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor() {
        
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
}

