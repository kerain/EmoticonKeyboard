//
//  UIColor+Extension.swift
//  大深圳微博01
//
//  Created by shenzhenIOS on 16/4/11.
//  Copyright © 2016年 shenzhenIOS. All rights reserved.
//

import UIKit

extension UIColor {
    /// 随机颜色
    ///
    /// - returns: 随机颜色
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256)) / 255.0
        let g = CGFloat(arc4random_uniform(256)) / 255.0
        let b = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}