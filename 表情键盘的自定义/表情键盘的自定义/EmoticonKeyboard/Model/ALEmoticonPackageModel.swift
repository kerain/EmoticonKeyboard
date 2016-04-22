//
//  ALEmoticonPackageModel.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/20.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit
 //MARK: - 全区的变量
let numberOfPage = 20

//表情包模型 表情包名称 表情包对应的文件名称
class ALEmoticonPackageModel: NSObject {
//表情包对应的文件夹名称
    var id : String
    
    //表情包名称
    var group_name_cn:String
    
    /// 表情模型数组,所有表情模型都放一起
    var emoticons: [ALEmoticonModel]
    
    /// 所有页的表情,一页有20个表情
    var pageEmoticons: [[ALEmoticonModel]] = [[ALEmoticonModel]]()
    
    init(id:String ,group_name_cn: String,emoticons:[ALEmoticonModel]) {
        self.id = id
        self.group_name_cn = group_name_cn
        self.emoticons = emoticons
        
        super.init()
        
        //将所有的表情拆分成多页,一页有20个表情
        splitEmoticons()
    }
    
    //将所有的模型拆分成多页,一页有20个模型,可以拆成多页
    private func splitEmoticons(){
        // 计算总页数 = (总数量 + 一页表情数 - 1) / 一页表情数
        let pageCount = (emoticons.count + numberOfPage - 1) / numberOfPage

        //如果没有没有表情的时候就生成一页空的
        if pageCount == 0 {
            let pageEmoticon = [ALEmoticonModel]()
            pageEmoticons.append(pageEmoticon)
        }
        //分割每一页
        for i in 0..<pageCount {
            let location = i*numberOfPage
            var length = numberOfPage
            
            //判断最后一页是不是越界,如果越界的话重新计算当前页的长度
            if location + length > emoticons.count {
                length = emoticons.count - location
            }
            //数组分割
            let range = NSRange(location: location, length: length)
            
            let subEmoticons = (emoticons as NSArray).subarrayWithRange(range) as! [ALEmoticonModel]
            
            pageEmoticons.append(subEmoticons)
        }
    }
}
