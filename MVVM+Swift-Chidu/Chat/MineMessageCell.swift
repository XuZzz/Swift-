//
//  MineMessageCell.swift
//  MVVM+Swift-Chidu
//
//  Created by Xu on 2018/6/26.
//  Copyright © 2018年 com.delinshe. All rights reserved.
//

import UIKit
import Kingfisher

class MineMessageCell: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var basicImage: UIImageView!
    
    var const: XZConstClass = XZConstClass()
    var basic_view: UIView?
    
    var model: ChatModel? {
        
        didSet{
            message.isHidden = false
            basicImage.isHidden = true
            self.basic_view = UIView()
            self.message.textColor = UIColor.black
            self.message.textAlignment = .right
            
            if model?.message != const.EMPTY_STRING && model?.message != nil {
                
                message.text = (model?.message)!
            }
            else{
                if model?.expressions != const.EMPTY_STRING{
                    message.isHidden = true
                    basicImage.isHidden = false
                    let imageUrl = URL(string: const.kImageHost + (model?.expressions)!)
                    basicImage.kf.setImage(with: ImageResource(downloadURL: imageUrl!))
                    
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
