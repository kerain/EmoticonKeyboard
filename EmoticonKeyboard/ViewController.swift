//
//  ViewController.swift
//  表情键盘的自定义
//
//  Created by 柴瑞军 on 16/4/19.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textV)

        textV.translatesAutoresizingMaskIntoConstraints = false
        
        
        //设置约束
        setConstraint()
        
    }

    //设置约束
    private func setConstraint(){
        view.addConstraint(NSLayoutConstraint.init(item: textV, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint.init(item: textV, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -100))
        
        view.addConstraint(NSLayoutConstraint.init(item: textV, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250))
        
        view.addConstraint(NSLayoutConstraint.init(item: textV, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250))
    }
    
    
    private lazy var textV :UITextView = {
    let textV = UITextView()
    
        textV.alwaysBounceVertical = true
        textV.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        textV.becomeFirstResponder()
        textV.backgroundColor = UIColor.lightGrayColor()
        let keyboardView = EmotionkeyBoard()

        textV.inputView = keyboardView
        
        //TODO:此处如果没有设置文字的时候,而且在插入表情的方法中写
        let dateFormator = NSDateFormatter()
        dateFormator.dateFormat = "当前日期:yyyy-MM-dd  HH:mm"
        
        textV.text = dateFormator.stringFromDate(NSDate())
        //设置大小为32 ,是为了保证文字和表情图片的大小一致
        textV.font = UIFont.systemFontOfSize(20)
        keyboardView.textView = textV
        return textV
    }()
    
    //获取textView中的文本属性
    //TODO:模拟发送内容到服务器----发送给服务器的是字符串
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let textString = textV.emoticonText()
        print("\(textString)")

    }
}

