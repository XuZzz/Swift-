//
//  ControlView.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/27.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class ControlView: XZBaseView {

    @IBOutlet weak var sendFaceButton: UIButton!
    
    typealias clickFace = (UIButton,ControlView) -> Void
    
    var faceBlock: clickFace?
    
    override func awakeFromNib() {
        print("ControlView 已被加载")
    }

    @IBAction func faceAction(_ sender: UIButton) {
        
        if faceBlock != nil{
            faceBlock!(sender,self)
        }
    }
}
