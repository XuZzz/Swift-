//
//  ViewController.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/21.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    lazy var chatView: ChatView = {
        let manager = SocketManager.sharedInstance()
        let tmp_view = ChatView(frame: self.view.bounds, manager: manager, viewModel: viewModel)
        return tmp_view
    }()
    
    lazy var viewModel: ChatViewModel = {
        let view_model = ChatViewModel()
        return view_model
    }()
    
    var con_view: ControlView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(chatView)
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "聊天室"
        
        setupRightBarItem()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(note:)) , name:NSNotification.Name.UIKeyboardWillChangeFrame , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        chatView.controlView?.faceBlock = { (sender,controlView) in
            
            self.openImagePicker()
        }
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

/**
 * 相机相关
 */
extension ChatViewController {
    
    func openImagePicker() {
        let pickerImage:UIImagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        
        self.present(pickerImage, animated: true, completion: nil)
    }
    /**
     * delegate
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type: String = info[UIImagePickerControllerMediaType] as! String
        if type == "public.image"{
            
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            var new_data: Data = Data()
            new_data = UIImageJPEGRepresentation(image, 0.5)!
            
            let base64String: String = new_data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            chatView.getSelectedImage(encodingString: base64String)
        }
        
        con_view?.alpha = 1.0
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController {
    
    func setupRightBarItem() {
        
        
        let item = UIBarButtonItem(customView: self.chatView.barButton)
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func keyboardWillChangeFrame(note: Notification){
        
        chatView.keyboardChange(note: note)
    }
    
    @objc func keyboardWillShow(note: Notification){
        
        chatView.keyboardWillShow(note: note)
    }
    
    @objc func keyboardWillHide(note: Notification){
        
        chatView.keyboardWillHide(note: note)
    }
}
