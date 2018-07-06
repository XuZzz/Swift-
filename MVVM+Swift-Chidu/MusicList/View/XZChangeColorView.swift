//
//  XZChangeColorView.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/14.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import Lottie

class XZChangeColorView: UIView {

    lazy var changeColorBtn: UIButton = {
        let button = UIButton(type: .custom);
        button.frame = CGRect(x: 10, y: 100, width: 88, height: 44);
        button.setTitle("Change Color", for: .normal);
        button.setTitleColor(.white, for: .normal);
        button.backgroundColor = .orange;
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .thin)
        button.addTarget(self, action: #selector(changeColorAction), for: .touchUpInside);
        return button;
    }()
    
    

    var view_model:XZChangeColorViewModel!;
    
    typealias actionBlock = (UIButton)-> Void
    
    var didClockBlock: actionBlock?
    
    init(frame: CGRect,viewModel: XZChangeColorViewModel){
        
        super.init(frame: frame);
        
        view_model = viewModel;
        
        creatUI()
        
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    deinit {
        // Nothing to do s
    }
}

fileprivate extension XZChangeColorView {
    
    func creatUI() {
        
        addSubview(self.changeColorBtn);
        
        let animationView = LOTAnimationView(name: "data.json", bundle: Bundle.main)
        animationView.loopAnimation = true
        
        self.addSubview(animationView)
        animationView.play { (finished) in
            // do something
        }
        
        animationView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    func bindViewModel() {
    
        self.view_model.reactive.producer(forKeyPath: "color").filter { (value) -> Bool in
            
            if value == nil {return false}
            return true
            
            }.startWithValues { (value) in
                self.backgroundColor = value as? UIColor
        }
    }
    
    @objc func changeColorAction(sender: UIButton){
        
        view_model.getColorData()
        
        if didClockBlock != nil {
            didClockBlock!(sender)
        }
    }
}

