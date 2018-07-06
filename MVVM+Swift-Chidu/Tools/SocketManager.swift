//
//  SocketManager.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/20.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import SocketRocket
import ReactiveCocoa
import ReactiveSwift
import Result
import HandyJSON

enum SocketConnectStatus: String {
    case UnConnected = "UnConnected"     //未连接状态
    case Connected = "Connected"         //连接状态
    case DisconnectByUser = "DisconnectByUser" //主动断开连接
    case Unknow     = "Unknow"        //未知,失败
}

enum ResponseType: String {
    case connect  = "connect"          // 连接成功
    case ping = "ping"   // 心跳
    case join_success  = "join_success"      // 本人加入群聊成功
    case join_group    = "join_group"      // 其他用户加入群聊成功
    case send_message   = "send_message"     // 收到消息
    case send_expressions = "send_expressions" // 收到图片消息
    case leave         = "leave"      // 退出群聊成功
    case get_user_list  = "get_user_list"     // 获取当前群聊成员列表
}

protocol SocketManagerDelegate {
    
    func socketManager(status: SocketConnectStatus)
    func socketManager(didReceiveMessage: Dictionary<String, Any>)
}

class SocketManager: NSObject, GCDAsyncSocketDelegate,SRWebSocketDelegate {
    
    static let instance: SocketManager = SocketManager()
    
    class func sharedInstance() -> SocketManager{
        
        return instance
    }
    
    var socket: GCDAsyncSocket!
    
    var new_socket: SRWebSocket!
    
    lazy var const: XZConstClass = {
        let tmp_const = XZConstClass()
        
        return tmp_const
    }()
    
    
    var request:URLRequest?
    
    public var delegate: SocketManagerDelegate?
    
    public var connnectStatus:SocketConnectStatus = .UnConnected // 连接状态

    override init() {
        super.init()
        
        request = URLRequest(url: URL.init(string: self.const.kConnectHost)!)
        initSocket(reuqest: request!)
    }
}

extension SocketManager {
    
    // 手动断开连接
    func disconnect() {
        new_socket.close()
        new_socket = nil
        connnectStatus = .DisconnectByUser
        triggerDelegate(status: connnectStatus)
    }
    
    func initSocket(reuqest: URLRequest) {
        new_socket = SRWebSocket.init(urlRequest: reuqest)
        new_socket.delegate = self
    }
    
    // 手动连接
    func connect() {
        if new_socket == nil{
            initSocket(reuqest: request!)
        }
        new_socket.open()
    }
    
    func sendBeat() {
        connnectStatus = .Connected
        let string = "{\"type\":\"pong\"}"
        let data = string.data(using: String.Encoding.utf8)
        self.new_socket.sendPing(data)
        print("发送了心跳")
    }
    
    func sendMessage(msg: String , timeOut: Int, tag: Int){
        
        if connnectStatus != SocketConnectStatus.Connected {
            connect()
        }else{
            let dict = ["type":"send_message" , "request":["user_id": "12171", "group": "1" , "message": msg]] as [String : Any]
            
            let jsonString: String = self.const.convertDictionaryToString(dict: dict as [String : AnyObject])
            
            self.new_socket.send(jsonString)
        }
    }
    
    func senEmoj(base64String: String, timeOut: Int, tag: Int){
        
        if connnectStatus != SocketConnectStatus.Connected {
            connect()
        }else{
            let dict = ["type":"send_expressions" , "request":["user_id": "12171", "group": "1" , "expressions": base64String]] as [String : Any]
            let jsonString: String = self.const.convertDictionaryToString(dict: dict as [String : AnyObject])
            
            self.new_socket.send(jsonString)
        }
    }
    
    fileprivate func triggerDelegate(status: SocketConnectStatus) {
        
        if delegate != nil{
            delegate?.socketManager(status: status)
        }
    }
    fileprivate func didGetMessage(message: Dictionary<String , Any>){
        
        if delegate != nil {
            
            delegate?.socketManager(didReceiveMessage: message)
        }
    }
    
}
// MARK: Delegate
extension SocketManager {
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("已经连接")
        let dict = ["type":"join","request":["user_id":"12271","group":"1"]] as [String : Any]
        
        let jsonString: String = self.const.convertDictionaryToString(dict: dict as [String : AnyObject])
        self.new_socket.send(jsonString)
        sendBeat()
        connnectStatus = .Connected
        
        triggerDelegate(status: connnectStatus)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("断开连接")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print(message)
        let dict: Dictionary = self.const.convertStringToDictionary(text: message as! String)!

        
        if dict["type"] as! String == "ping" {
            sendBeat()
        }else{
            didGetMessage(message: dict)
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        let str:String = String(data: pongPayload, encoding: String.Encoding.utf8)!
        print(str)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        connnectStatus = SocketConnectStatus.Unknow
    }
}

extension SocketManager {
    
}
