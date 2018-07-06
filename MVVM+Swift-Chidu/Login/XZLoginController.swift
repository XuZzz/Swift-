//
//  XZLoginController.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/15.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class XZLoginController: UIViewController {
    
    private lazy var loginView: LoginView = {
       
        let frame = self.view.bounds
        let view = LoginView(viewModel: viewModel, frame: frame)
        return view
        
    }()
    
    private lazy var viewModel: LoginViewModel = {
        
        let viewmodel = LoginViewModel()
        
        return viewmodel
        
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.view.addSubview(loginView)
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
