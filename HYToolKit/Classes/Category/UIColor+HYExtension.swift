//
//  UIColor+HYExtension.swift
//  HYToolKit
//
//  Created by HY on 2019/9/23.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

public extension UIColor {
  
  
  /// 生成随机颜色
  /// - Parameter alpha: 是否透明
  static func random(alpha: Bool = false) -> UIColor {
    return RGBA(CGFloat(arc4random()%255),
                CGFloat(arc4random()%255),
                CGFloat(arc4random()%255),
                alpha ? CGFloat(arc4random()%255) : 1)
  }
  
  
  /// 使用0-255创建UIColor
  /// - Parameter r: 红 0-255
  /// - Parameter g: 绿 0-255
  /// - Parameter b: 蓝 0-255
  /// - Parameter a: 透明度，默认1
  static func RGBA(_ r: CGFloat,
                          _ g: CGFloat,
                          _ b: CGFloat,
                          _ a: CGFloat = 1) -> UIColor {
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
  }
  
  /// 创建半透明白色
  /// - Parameter alpha: 透明度
  static func white(alpha: CGFloat) -> UIColor {
    return UIColor.init(white: 1, alpha: alpha)
  }
  
  /// 创建半透明黑色
  /// - Parameter alpha: 透明度
  static func black(alpha: CGFloat) -> UIColor {
    return UIColor.init(white: 0, alpha: alpha)
  }
  
  /// 获取颜色的hex值
  var hex: String {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(red * 255) << 0
    
    return String(format: "#%06x", rgb)
  }
  
  /// 使用16进制色值字符串来创建UIColor
  /// - Parameter hexString: "0x000000"/"#000000"
  /// - Parameter alpha: 透明度，默认1
  convenience init(_ hexString: String, _ alpha: CGFloat = 1) {
    var colorStr = hexString.replacingOccurrences(of: "0x", with: "")
    colorStr = colorStr.replacingOccurrences(of: "#", with: "")
    if let hex = Int(colorStr, radix: 16) {
      let red = CGFloat((hex >> 16) & 0xFF)/255.0
      let green = CGFloat((hex >> 8) & 0xFF)/255.0
      let blue = CGFloat(hex & 0xFF)/255.0
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    } else {
      self.init(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
  
  /// 使用16进制色Int值来创建UIColor
  /// - Parameter hex: 0x000000
  /// - Parameter alpha: 透明度，默认1
  convenience init(_ hex: Int32, _ alpha: CGFloat = 1) {
    let red = CGFloat((hex >> 16) & 0xFF)/255.0
    let green = CGFloat((hex >> 8) & 0xFF)/255.0
    let blue = CGFloat(hex & 0xFF)/255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
