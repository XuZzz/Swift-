//
//  XZPlayer.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/15.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveCocoa
import ReactiveSwift
import Result

protocol XZPlayerDelegate {
    
    // play And Pause
    func playerDidPlayed(player: AVPlayer, playerItem: AVPlayerItem, url: String)
    func playerDidPause(player: AVPlayer, playerItem: AVPlayerItem, url: String)
    
    // status
    func playerStatusChanged(player: AVPlayer, playerItem: AVPlayerItem , status:XZPlayer_Status)
}

enum XZPlayer_Status:Int {
    case unkonwn
    case playing
    case pausing
    case stopping
    case failed
}

class XZPlayer: NSObject {
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var delegate: XZPlayerDelegate?
    var currentStatus: XZPlayer_Status?{
        
        willSet{
            print(currentStatus!)
        }
        didSet{
            if delegate != nil {
                delegate?.playerStatusChanged(player: player!, playerItem: playerItem!, status: currentStatus!)
            }
        }
    }
    
    public var url: String?{
        
        // 在Url数据改变前，可以在willset中做些什么
        willSet{
            print(url!);
        }
        
        didSet{
            if url != nil {
                initPlayer(url: url!)
            }
        }
    }
    
    func initPlayer(url: String){
        
        playerItem = AVPlayerItem(url: URL(string: url)!);
        player = AVPlayer(playerItem: playerItem);
        player?.play()
        
        self.player?.reactive.producer(forKeyPath: "status").startWithValues({ [weak self](value) in
            
            if value as? Int == 1{
                self?.currentStatus = XZPlayer_Status.playing
                self?.play()
            }
            else if value as? Int == 0{
                self?.currentStatus = .unkonwn
            }
            else{
                self?.currentStatus = .failed
            }
        })
    }
}

extension XZPlayer {
    
    public func play() {
        
        player?.play()
        
        if delegate != nil {
            delegate?.playerDidPlayed(player: self.player!, playerItem: self.playerItem!, url: self.url!)
        }
    }
    
    public func pause() {
        
        player?.pause()
        
        if delegate != nil {
            delegate?.playerDidPause(player: self.player!, playerItem: self.playerItem!, url: self.url!)
        }
    }
    
    public func stop() {
        player?.pause()
        player?.rate = 0
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
}
