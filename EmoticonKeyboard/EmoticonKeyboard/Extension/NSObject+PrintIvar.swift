//
//  NSObject+PrintIvar.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/21.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit
extension NSObject{
    class func printIvars() {
        // 运行时.获取类里面的 _成员变量
        // outCount: UnsafeMutablePointer<UInt32>: UInt32类型的可变
        var outCount: UInt32 = 0    // _成员变量的数量
        // ivars实际上是一个数组
        let ivars = class_copyIvarList(self, &outCount)
        
        // 获取里面的每个元素
        
        for i in 0..<outCount {
            // ivar是一个结构体的指针
            let ivar = ivars[Int(i)]
            
            // 获取 _成员变量的名称
            let cName = ivar_getName(ivar)  // cNamec语言的字符串,首元素的地址
            let name = String(CString: cName, encoding: NSUTF8StringEncoding)
            print("name: \(name)")
        }
        
        // 需要释放
        free(ivars)
    }
}