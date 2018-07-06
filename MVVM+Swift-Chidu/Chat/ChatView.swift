//
//  ChatView.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/21.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit

class ChatView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var const: XZConstClass = XZConstClass()
    
    let cell_identifier = "OtherPeopleCell"
    let mine_identifier = "MineMessageCell"
    
    let controlViewHeight = 200
    
    lazy var tableview: UITableView = {
        
        let tmp_table = UITableView(frame: CGRect(x: 0, y: 0, width: const.SCREEN_WIDTH, height: const.SCREEN_HEIGHT - 80), style: .grouped)
        tmp_table.delegate = self
        tmp_table.dataSource = self
        tmp_table.backgroundColor = UIColor.groupTableViewBackground
        tmp_table.separatorStyle = .none
        tmp_table.register(UINib(nibName: "OtherPeopleCell", bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        tmp_table.register(UINib(nibName: "MineMessageCell", bundle: Bundle.main), forCellReuseIdentifier: mine_identifier)
        tmp_table.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tmp_table.showsVerticalScrollIndicator = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(tap:)))
        tap.numberOfTapsRequired = 1;
        tap.cancelsTouchesInView = false;
        tmp_table.addGestureRecognizer(tap)
        return tmp_table
    }()
    
    lazy var inputTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.thin)
        textfield.textColor = UIColor.black
        textfield.textAlignment =  NSTextAlignment.left
        textfield.borderStyle = UITextBorderStyle.roundedRect
        textfield.placeholder = "想说什么?"
        textfield.returnKeyType = .send
        textfield.delegate = self
        return textfield
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(sendAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var barButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        button.setTitle("连接", for: .normal)
        button.setTitle("断开", for: .selected)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.red, for: .selected)
        button.addTarget(self, action: #selector(connectAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var dataSource: Array<ChatModel> = Array() // 数据源，聊天
    
    lazy var bottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    var socketManage: SocketManager? // socket 单例类
    var view_model: ChatViewModel?   // viewmodel
    var show_controlview = false     // 是否显示控制界面
    var controlView: ControlView?    // 控制界面
    var keyboardHeight: CGFloat = 0  // 键盘高度 留作备用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, manager: SocketManager, viewModel: ChatViewModel) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        socketManage = manager
        view_model = viewModel
        self.isUserInteractionEnabled = true
        setupUI()
        loadData()
        inputTextField.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControlEvents.allTouchEvents)
    }
}

// MARK: UI
extension ChatView {
    
    fileprivate func setupUI() {
        
        controlView = (Bundle.main.loadNibNamed("ControlView", owner: self, options: nil)?.first as! ControlView)
        controlView?.tag = 9999
        
        addSubview(tableview)
        addSubview(inputTextField)
        addSubview(sendButton)
        
        inputTextField.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-34)
            make.size.height.equalTo(55)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputTextField)
            make.left.equalTo(inputTextField.snp.right).offset(15)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(inputTextField).offset(-16)
        }
    
    }
    fileprivate func loadData(){
        dataSource = Array()
        view_model?.modelBlock = { [weak self](model) in

            if ((model.modelType == ResponseType.send_message.rawValue) || (model.modelType == ResponseType.send_expressions.rawValue)){
            
                self?.dataSource.append(model)
                
                self?.tableview.reloadData()
                
                self?.scrollToBottom()
            }
            else{
                print(model.message)
            }
        }
    }
    
    func keyboardChange(note: Notification) {
        
    }
    func keyboardWillShow(note: Notification) {
        let frame: CGRect = note.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        textfieldChange(frame: frame, type: 1001)
    }
    
    func keyboardWillHide(note: Notification) {
        let frame: CGRect = note.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        if show_controlview {
            textfieldChange(frame: frame, type: 1003) // 显示控制中心情况
        }
        else{
            textfieldChange(frame: frame, type: 1002)
        }
        
    }
    
    func textfieldChange(frame: CGRect, type: Int){
        
        if type == 1001 {
             // willshow
            keyboardHeight = frame.size.height
            inputTextField.snp.updateConstraints { (make) in
                make.bottom.equalTo(-(const.SCREEN_HEIGHT - frame.origin.y + 3))
            }
            UIView.animate(withDuration: 0.1) {
                self.tableview.frame = CGRect(x: 0, y: 0, width: self.const.SCREEN_WIDTH, height: self.const.SCREEN_HEIGHT - frame.size.height - 60)
            }
        }
        else if type == 1002{
            // willhide
            inputTextField.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-34)
            }
            
            self.tableview.frame = self.bounds
        }
        else if type == 1003{
            inputTextField.snp.updateConstraints { (make) in
                make.bottom.equalTo(-(controlViewHeight + 3))
            }
            UIView.animate(withDuration: 0.1) {
                self.tableview.frame = CGRect(x: 0, y: 0, width: self.const.SCREEN_WIDTH, height: self.const.SCREEN_HEIGHT - frame.size.height - 60)
            }
        }
    
        scrollToBottom()
    }
    
    @objc func textField1TextChange(textfield: UITextField){
        
        show_controlview = false
        sendButton.isSelected = false
        isShowControlView(isShow: false)
    }
    
    /**
     * 调出控制面板
     */
    @objc func sendAction(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        show_controlview = sender.isSelected
        
        isShowControlView(isShow: sender.isSelected)
        
        self.inputTextField.becomeFirstResponder()
        
        if sender.isSelected {
            self.endEditing(true)
        }
    }
    
    func isShowControlView(isShow: Bool) {
        
        if isShow{
            // 收起键盘，显示控制面板
            for view in self.subviews{
                if view.tag == 9999{
                        print("有！")
                }
            }
            addSubview(controlView!)
            
            controlView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(self.inputTextField.snp.bottom)
                make.bottom.equalTo(self.snp.bottom)
            })
            
            controlView?.alpha = 1.0
        }else{
            // 隐藏控制键盘，显示键盘
            UIView.animate(withDuration: 0.5, animations: {
                self.controlView?.alpha = 0.0
            }) { (finish) in
                self.controlView?.removeFromSuperview()
            }
        }
    }
    
    func scrollToBottom(){
        
        if dataSource.count > 0{
            let indexPath: IndexPath = IndexPath(row: 0, section: self.dataSource.count - 1)
            tableview.scrollToRow(at: indexPath, at: UITableViewScrollPosition(rawValue: 0)!, animated: true)
        }
    }
    
    func sendMessage() {
        // 发送消息
        let text = self.inputTextField.text
        
        if  text != const.EMPTY_STRING && text != nil {
            
            socketManage?.sendMessage(msg: text!, timeOut: -1, tag: 9999)
            
            self.inputTextField.text = ""
        }
        else{
            print("不能发送空内容")
        }
    }
    
    func sendEmoj(str: String){
        if str != const.EMPTY_STRING{
            self.socketManage?.senEmoj(base64String: str, timeOut: -1, tag: 9998)
        }
    }
    
    @objc func connectAction(sender: UIButton){
    
        if sender.isSelected {
            socketManage?.disconnect()
        }
        else{
            // 连接
            socketManage?.connect()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc func hideKeyBoard(tap: UITapGestureRecognizer){
        
        self.endEditing(true)
        inputTextField.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-34)
            make.size.height.equalTo(55)
        }
        self.tableview.frame = CGRect(x: 0, y: 0, width: self.const.SCREEN_WIDTH, height: const.SCREEN_HEIGHT - 80)
        isShowControlView(isShow: false)
        scrollToBottom()
    }
}

// MARK: 发送表情
extension ChatView {
    
    /**
     * First 得到选中的图片
     */
    open func getSelectedImage(encodingString: String) {
        
        // 准备上传
        sendEmoj(str: encodingString)
    }
    
}

// MARK: Textfield Delegate
extension ChatView {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendMessage()
        
        return true
    }
}

// MARK: Tableview Delegate
extension ChatView {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model: ChatModel = self.dataSource[indexPath.section]
        
        let user_id = (model.userId)!
        
        let mine_userID = const.mine_userID
        
        if Double(user_id) == mine_userID{
            // MineCell
            let cell: MineMessageCell = tableView.dequeueReusableCell(withIdentifier: mine_identifier) as! MineMessageCell
            cell.contentView.backgroundColor = UIColor.groupTableViewBackground
            cell.model = model
            return cell
        }
        else{
            // OtherCell
            let cell: OtherPeopleCell = tableView.dequeueReusableCell(withIdentifier: cell_identifier) as! OtherPeopleCell
            cell.contentView.backgroundColor = UIColor.groupTableViewBackground
            cell.model = model
            return cell
        }
    }
}
