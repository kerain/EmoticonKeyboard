//
//  ALEmoticonManager.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/21.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit

let emoticonBundle = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")
/// 一页显示20个表情模型
let ALEmoticonNumberOfPage = 20

/// 一页7列
let ALEmoticonColumnOfPage = 7

/// 一页3行
let ALEmoticonRowOfPage = 3

/// 该文件的主要作用:就是用单例来加载/保存表情模型和表情包模型
class ALEmoticonManager: NSObject {
//定义单例
    static let shareManager : ALEmoticonManager = ALEmoticonManager()
    
    private let emoticonPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/emoticons.plist"
    //外界通过这个属性可以访问所有的表情---这样的话所有的表情包只会加载一次
    lazy var packageModels: [ALEmoticonPackageModel] = self.loadPackages()
    
    /// 表情包模型是从bundle里面加载出来的,bundle是在磁盘上.如果多次加载是比较耗性能,而且bundle加载出来是不会变,只需要加载一次
    /// 加载所有表情包
    private func loadPackages() -> [ALEmoticonPackageModel]{
    
        //加载最近的表情包
        let recentPackage = ALEmoticonPackageModel(id: "", group_name_cn: "最近", emoticons: loadRecentEmoticon())
        
        //TODO:在本地加载的时候可以将此
        
        let defaultPackage = loadPackage("com.sina.default")
        let emojiPackage = loadPackage("com.apple.emoji")
        let lxhPackage = loadPackage("com.sina.lxh")
//将数据进行返回
        return [recentPackage,defaultPackage,emojiPackage,lxhPackage]
    }
    /// 加载表情包
    ///
    /// - parameter id: 表情包文件夹名称
    /// 返回表情包模型
    private func loadPackage(id:String) ->ALEmoticonPackageModel{
        // 解析id文件夹下的info.plist
        // info.plist的路径 = Emoticons.bundle的路径/id/info.plist
      //加载bundleId

        
        let infoPath = emoticonBundle! + "/" + id + "/" + "info.plist"
        
        let infoDict = NSDictionary(contentsOfFile: infoPath)
        
        //解析包内容
        let group_name_cn = infoDict!["group_name_cn"] as! String
        
        var emoticans = [ALEmoticonModel]()
        
        //表情数组中存放的是字典,对其进行赋值
        if let emoticonsArray = infoDict!["emoticons"] as? [[String:String]]{
        //遍历数组,获取里面的字典,进行字典转模型
            for dict in emoticonsArray {
                //表情字典转模型
                let model = ALEmoticonModel(dict: dict,id:id)
                emoticans.append(model)
            }
        }
        
        //返回表情包
        return ALEmoticonPackageModel(id: id, group_name_cn: group_name_cn, emoticons: emoticans)
    }
    
    //添加最近的表情
    func addRecentEmoticon(emoticon:ALEmoticonModel){
        //首先要获取到最近这一要的表情----第0组,第0页对应的所有的模型
        var recentPageEmoticons = packageModels[0].pageEmoticons[0]
        
        //记录相同的表情
        var sameEmoticon :ALEmoticonModel?
        
        //判断是否存在一样的表情
        for emoticonP in recentPageEmoticons {
            //获取现有的表情,判断是不是同一个表情
            if (emoticon.emoji != nil && emoticonP.code == emoticon.code)  || (emoticon.chs != nil && emoticonP.chs == emoticon.chs){
                sameEmoticon = emoticonP
            }
        }
        
        //如果存在一样的就先将之前的进行删除
        if sameEmoticon != nil {
            //找出该模型在模型数组中的位置进行删除
            let index = recentPageEmoticons.indexOf(sameEmoticon!)
            
            recentPageEmoticons.removeAtIndex(index!)
        }
        //将相同的模型放到数组的第一个元素的位置
        recentPageEmoticons.insert(emoticon, atIndex: 0)
        
        
        //判断数组中元素的个数,不能超过20个,因为按钮的数量只有20个,d当超出的时候删除最后一个元素
        if recentPageEmoticons.count > 20 {
            recentPageEmoticons.removeLast()
        }
        
        //将最近的表情添加到数组中--添加到最前面
        //swift中的数组和oc中的数组不同,,在进行取值的时候会进行只传递,相当于oc中的copy属性.,所以当添加模型到数组中以后要将数组再次赋值回去
        
        packageModels[0].pageEmoticons[0] = recentPageEmoticons
        
        
        //保存表情到沙盒中
        saveRecentEmoticon()
    }
    
    
    //保存最近使用的表情到本地---由于保存的是模型,因此使用解档和归档的形式进行保存数据和读取数据
    func saveRecentEmoticon() {
        NSKeyedArchiver.archiveRootObject(packageModels[0].pageEmoticons[0], toFile: emoticonPath)
    }
    
    //解档数据
    func loadRecentEmoticon() -> [ALEmoticonModel]{
        if let emoticons = NSKeyedUnarchiver.unarchiveObjectWithFile(emoticonPath) as? [ALEmoticonModel] {
            return emoticons
        }else{
        //没有加载到数据,返回空数组
            return [ALEmoticonModel]()
        }
    }
}

