//
//  UITextView+emoticon.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/22.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit
extension UITextView{

    //获取textView中的属性文本内容的拓展方法
    func emoticonText() -> String {
        
        //定义一个空的字符串用来拼接内容
        var strM = ""
        
        //属性文本会分段保存,普通文本是一段,emoji是一段,图片表情是一段
        //获取属性文本中的每一段
        //打印textView中的内容---打印出的文本中只能获取到普通字符串的emoji表情...不能得到图片,所有要通过属性文本获取
        //        当字典里面包含 NSAttachment key表示是一个附件, 只包含 NSFont 表示普通文本,将分段的附件拼接起来
        //        print("\(textV.text)")
        
        //遍历获取属性文本中的每一段
        attributedText.enumerateAttributesInRange(NSRange(location: 0,length: attributedText.length), options: []) { (dict, range, _) in
            print("dict:\(dict)")
            print("range:\(range)")
            // 图片表情 dict里面会包含 NSAttachment key, 获取图片表情的名称
            if let atta = dict["NSAttachment"] as? ALtextAttachment{
                
                //此处需要拼接的是图片的名称,图片的名称保存在了模型中是chs属性
                //因此自定义附件,让附件具有图片的名称
                
                strM += atta.chs!
            }else{
                //进入else中标识textView的文本内容不是图片
                //直接截取对应的内容
                let text = (self.attributedText.string as NSString).substringWithRange(range)
                strM += text
            }
        }
        
        return strM
    }
    
    
    //textView中插入图片的方法
    func insertIcon(emoticon:ALEmoticonModel) {

        // 1.emoji表情
        if let emoji = emoticon.emoji {
            insertText(emoji)
            return
        }
        
        // 2.图片表情
        if let png = emoticon.fullPngPath {
            // 将图片添加textView, textView可以显示属性文本
            // 1.将图片添加到附件
            let attachment = ALtextAttachment()
            attachment.image = UIImage(named: png)
            
            // 把模型对应的名称发到附件中
            attachment.chs = emoticon.chs
            
            // 1.1设置附件的bounds
            let wh = font?.lineHeight ?? 15
            // bounds.y 和 frame.y: frame往下走y是正数, bounds往下走y是负数
            attachment.bounds = CGRect(x: 0, y: -5, width: wh, height: wh)
            
            // 2.将附件转成属性文本
            let attrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            // 2.1 附件没有font属性跟在他后面的图片就会变的很小
            attrM.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: 0, length: 1))
            
            // 2.2将带 图片的属性文本 ,替换现有文本光标位置
            let currentText = NSMutableAttributedString(attributedString: attributedText)
            
            // 当前光标的位置
            let currentSelectedRange = selectedRange
            
            currentText.replaceCharactersInRange(currentSelectedRange, withAttributedString: attrM)
            
            // 3.textView设置属性文本
            attributedText = currentText
            
            // 设置光标的位置
            selectedRange = NSRange(location: currentSelectedRange.location + 1, length: 0)
        }

    }
}