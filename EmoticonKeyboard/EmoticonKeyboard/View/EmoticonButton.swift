//
//  EmoticonButton.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/21.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit
//表情模型按钮,更具传入的表情,来显示相应的按钮的内容
class EmoticonButton: UIButton {
    var emoticonModel:ALEmoticonModel?{
        didSet{
            //TODO:设置按钮的内容
            
            if let emoji = emoticonModel?.emoji{
                setTitle(emoji, forState: UIControlState.Normal)
                setImage(nil, forState: UIControlState.Normal)
            }else{
                setImage(UIImage(named: emoticonModel!.fullPngPath!), forState: UIControlState.Normal)
                setTitle(nil, forState: UIControlState.Normal)
            }

        }
    }
}
