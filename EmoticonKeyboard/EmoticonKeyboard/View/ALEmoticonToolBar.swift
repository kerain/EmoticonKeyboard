//
//  ALEmoticonToolBar.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/20.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit

//按钮的类型
enum ALEmoticonToolBarType: Int{

    case Recent = 0
    case Default = 1
    case Emoji = 2
    case Lxh = 3
}

//当点击某一个按钮以后,按钮的处理事件应该交给EmoticonKeyboard来做相应的处理事件
//定义代理
protocol ALEmoticonToolBarDelegate:NSObjectProtocol{

    //定义代理方法
    func emoticonToolBar(toolBar:ALEmoticonToolBar, selectedButtonType type:ALEmoticonToolBarType)
}

class ALEmoticonToolBar: UIView {

    //定义代理的属性
    weak var delegate : ALEmoticonToolBarDelegate?
    
    
    //切换选中按钮的属性
    private var selectedButton:UIButton?
    
//加载xib
    class func emoticonToolBar()->ALEmoticonToolBar{
    return NSBundle.mainBundle().loadNibNamed("ALEmoticonToolBar", owner: nil, options: nil).last as! ALEmoticonToolBar
    }
    //监听按钮的点击事件
    @IBAction func didClickButton(sender:UIButton){
    
        let type = ALEmoticonToolBarType(rawValue: sender.tag)
//        print("\(type)")
        
        //调用代理
        delegate?.emoticonToolBar(self, selectedButtonType: type!)
        
        //进行跳转按钮
        switchSelectedButton(sender)
    }
    
    //跳转按钮的方法
    private func switchSelectedButton(button:UIButton){
    
        
        //判断按钮有没有处在选中的状态
        if button == selectedButton {
            return
        }
        
        selectedButton?.selected = false
        button.selected = true
        selectedButton = button
    }
    //定义一个外部可以直接访问的方法来改变button'的选中状态----有collectionView的section来设置button的selected
    
    func switchSelectButton(section:Int){
    //找到对应的按钮
        let button = self.subviews[section] as! UIButton
        
        switchSelectedButton(button)
    }
}
