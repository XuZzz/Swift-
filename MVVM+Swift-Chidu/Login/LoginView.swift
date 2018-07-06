//
//  LoginView.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/15.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    private lazy var phoneTF: UITextField? = {
        
        let textfield: UITextField = UITextField()
        
        textfield.textColor = UIColor.black
        
        textfield.borderStyle = .none
        
        textfield.font = UIFont.systemFont(ofSize: 13.0)
        
        textfield.placeholder = "Please Input Phone Number"
        
        return textfield
    }()
    
    private lazy var pwdTF: UITextField? = {
        
        let textfield: UITextField = UITextField()
        
        textfield.textColor = UIColor.black
        
        textfield.borderStyle = .none
        
        textfield.font = UIFont.systemFont(ofSize: 13.0)
        
        textfield.placeholder = "Please Input password"
        
        return textfield
    }()
    
    private lazy var loginBtn: UIButton? = {
        
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .orange
        
        button.setTitle("Login", for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(self.loginAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    
    var view_model: LoginViewModel?
    
    init(viewModel: LoginViewModel ,frame: CGRect){
        super.init(frame: frame)
        
        view_model = viewModel
        
        setUpUI()
        
        bindModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension LoginView {
    
    fileprivate func setUpUI() {
        
        addSubview(self.phoneTF!)
        addSubview(self.pwdTF!)
        addSubview(self.loginBtn!)
        
        self.phoneTF?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(80)
            make.size.equalTo(CGSize(width: 200, height: 50))
        })
        
        self.pwdTF?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo((self.phoneTF?.snp.bottom)!).offset(15)
            make.size.equalTo(CGSize(width: 200, height: 50))
        })
        
        self.loginBtn?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo((self.pwdTF?.snp.bottom)!).offset(50)
            make.size.equalTo(CGSize(width: 150, height: 40))
        })
    }
    
    fileprivate func bindModel() {
        
        self.phoneTF?.reactive.continuousTextValues.observeValues({ (value) in
            self.view_model?.model.phoneNumber = value
        })
        
        
        self.pwdTF?.reactive.continuousTextValues.observeValues({ (value) in
            self.view_model?.model.password = value
        })
    }
    
    @objc func loginAction(sender: UIButton) {
        
        let phone = (self.view_model?.model.phoneNumber)!
        let pwd = (self.view_model?.model.password)!
        print("phoneNumber:\(phone)")
        print("password:\(pwd)")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.phoneTF?.resignFirstResponder()
        self.pwdTF?.resignFirstResponder()
    }
}




