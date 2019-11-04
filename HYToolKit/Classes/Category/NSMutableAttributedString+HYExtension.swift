//
//  NSMutableAttributedString+HYExtension.swift
//  HYToolKit
//
//  Created by HY on 2019/9/24.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
  
  /// 根据{}来设置高亮文本"xx{TT}vxc{HY}n" -> "xxTTvxcHYn"
  /// - Parameter origText: 带指定符号的文本
  /// - Parameter normal: 普通样式
  /// - Parameter highlight: 高亮样式
  public static func createBy(_ origText: String, normal: Dictionary<NSAttributedString.Key, Any>, highlight: Dictionary<NSAttributedString.Key, Any>) -> NSMutableAttributedString {
    let strArr1 = origText.components(separatedBy: "}")
    
    let result = NSMutableAttributedString.init()
    
    for str1: String in strArr1 {
      let strArr2: Array = str1.components(separatedBy: "{")
      for i in 0..<strArr2.count {
        let attri = i == 0 ? normal : highlight
        result.append(NSAttributedString.init(string: strArr2[i], attributes: attri))
      }
    }

    return result
  }
  
  /// 根据highlightStr来查找需要高亮的文本
  /// - Parameter origText: 原始字符串
  /// - Parameter highlightText: 高亮字符串
  /// - Parameter normal: 普通样式
  /// - Parameter highlight: 高亮样式
  public static func createBy(_ origText: String, highlightText: String, normal: Dictionary<NSAttributedString.Key, Any>, highlight: Dictionary<NSAttributedString.Key, Any>) -> NSMutableAttributedString {
    let result = NSMutableAttributedString.init(string: origText, attributes: normal)
    
    if let range = origText.range(of: highlightText) {
      let nsrange = origText.nsRange(from: range)
      result.addAttributes(highlight, range: nsrange)
    }
    return result
  }
}
