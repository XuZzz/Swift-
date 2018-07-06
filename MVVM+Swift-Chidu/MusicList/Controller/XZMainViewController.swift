//
//  XZMainViewController.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/14.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import AVFoundation
import UIKit

class XZMainViewController: UIViewController {
    
    private lazy var colorView:XZChangeColorView = {
        let frame = self.view.frame;
        let view = XZChangeColorView(frame: frame, viewModel: self.colorViewModel);
        view.frame = self.view.bounds;
        return view;
    }()

    private lazy var colorViewModel:XZChangeColorViewModel = {

        let viewModel = XZChangeColorViewModel()
        return viewModel
    }()
    
    private var socManager: SocketManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.player.url = url!
        
        self.view.addSubview(colorView)
        
        colorView.didClockBlock = { (value) in
            
//            self.navigationController?.pushViewController(XZLoginController(), animated: true)
            self.socManager?.sendMessage(msg: "Hi", timeOut: 1, tag: 1)
        }
        
        socManager = SocketManager.sharedInstance()
    }
}






