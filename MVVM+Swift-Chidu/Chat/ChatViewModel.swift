//
//  ChatViewModel.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/21.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ChatViewModel: NSObject,SocketManagerDelegate{
    
    var chatModel: ChatModel = ChatModel()
    var connectStatus: SocketConnectStatus?
    var manager: SocketManager = SocketManager.sharedInstance()
    var const: XZConstClass = XZConstClass.init()
    
    typealias updateModel = (ChatModel) -> Void
    var modelBlock : updateModel?
    typealias updateStatus = (SocketConnectStatus) -> Void
    var statusBlock : updateStatus?
    
    override init() {
        super.init()
        chatModel = ChatModel()
        manager.delegate = self
        
    }
}

extension ChatViewModel {
    
    func socketManager(status: SocketConnectStatus) {
        
        if statusBlock != nil{
            statusBlock!(status)
        }
    }
    
    func socketManager(receiveNewMessage: String) {
        
    }
    
    func socketManager(didReceiveMessage: Dictionary<String, Any>) {
        
        var model = ChatModel()
        
        model = model.writeData(dict: didReceiveMessage)
        
        if modelBlock != nil {
            modelBlock!(model)
        }
    }
}


class ChatModel: NSObject {
    var const: XZConstClass = XZConstClass()
    var message: String?
    var userName: String?
    var userSex: String?
    var status: String?  // 状态
    var userId: String?
    var group: String?
    var head_img: String?
    var expressions: String? // 表情
    var modelType: String?    // 消息类型
    
    override init() {
        super.init()
        
        message = const.EMPTY_STRING
        userName = const.EMPTY_STRING
        userSex = const.EMPTY_STRING
        status = const.EMPTY_STRING
        userId = const.EMPTY_STRING
        head_img = const.EMPTY_STRING
        group = const.EMPTY_STRING
        expressions = const.EMPTY_STRING
        modelType = const.EMPTY_STRING
    }
    
    func writeData(dict: Dictionary <String , Any>) -> ChatModel{
        
        self.modelType = dict["type"] as? String
        var response : Dictionary<String , Any> = Dictionary()
        var new_message: String = const.EMPTY_STRING
        if (modelType != ResponseType.connect.rawValue) && (modelType != ResponseType.ping.rawValue) {
            
            response = dict["response"] as! Dictionary<String , Any>
            if modelType == ResponseType.send_expressions.rawValue{
                new_message = response["expressions"] as! String
            }
            else{
                new_message = response["message"] as! String
            }
        }
        
        if self.modelType == ResponseType.connect.rawValue{
            
            status = "连接成功:"
        }
        
        if self.modelType == ResponseType.join_success.rawValue{
            
            status = "加入聊天室成功:"
            message = new_message
        }
        
        if self.modelType == ResponseType.join_group.rawValue{
            
            status = "分组成功:"
            message = new_message
        }
        
        if self.modelType == ResponseType.send_message.rawValue{
            
            status = "收到新消息:"
            head_img = response["head_img"] as? String
            message = new_message
            userName = response["name"] as? String
            userId = response["user_id"] as? String
        }
        if self.modelType == ResponseType.send_expressions.rawValue{
            status = "收到新图片消息"
            head_img = response["head_img"] as? String
            expressions = new_message
            userName = response["name"] as? String
            userId = response["user_id"] as? String
        }
        if status == ResponseType.leave.rawValue{
            
        }
        if status == ResponseType.get_user_list.rawValue{
            
        }
        
        return self
    }
}
