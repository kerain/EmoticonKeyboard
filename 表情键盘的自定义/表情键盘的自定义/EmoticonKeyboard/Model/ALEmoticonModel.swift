//
//  ALEmoticonModel.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/20.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit
/// 表情符号的名称:包括中文名称和图片名称
class ALEmoticonModel: NSObject ,NSCoding{
    
    /// 表情模型所在文件夹
    var id: String

    
    //中文名称,(传输名称)
    var chs : String?
    
    //图片名称
    var png :String?{
        didSet{
        //拼接路径
            fullPngPath = emoticonBundle! + "/" + id + "/" + png!
        }
    }
    
    var fullPngPath : String?
    
    //表情使用的code
    var code: String?{
    
        didSet{
        
            //KVC设置code后,将code设置emoji
            //扫描 String -> Int
            let scanner = NSScanner(string: code!)
            
            var result:UInt32 = 0
            
            
            scanner.scanHexInt(&result)
            
            let scalar = UnicodeScalar(result)
            let c = Character(scalar)
            
            emoji = String(c)
        }
    
    }
    
    //emoji表情
    var emoji: String?
    
    //字典转模型
    init(dict:[String:String],id:String) {
        self.id = id
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    //重写打印的方法
    override var description: String{
        get{
        return  "\n\t\t:表情模型:chs:\(chs),png:\(chs),code:\(code)"
        }
    }
//    归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(chs, forKey: "chs")
        aCoder.encodeObject(png, forKey: "png")
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(emoji, forKey: "emoji")
    }
    
//    解档
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? String ?? ""
        self.chs = aDecoder.decodeObjectForKey("chs") as? String
        self.png = aDecoder.decodeObjectForKey("png") as? String
        self.code = aDecoder.decodeObjectForKey("code") as? String
        self.emoji = aDecoder.decodeObjectForKey("emoji") as? String

        super.init()
        if self.png != nil {
            self.fullPngPath = emoticonBundle! + "/" + id + "/" + png!
        }

    }
}
