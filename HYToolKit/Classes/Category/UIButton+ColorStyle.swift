//
//  UIButton+ColorStyle.swift
//  HYToolKit
//
//  Created by HY on 2019/9/25.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

public extension UIButton {
  
  /// 用背景色+边框颜色生成的图片作为按钮背景，设置标题颜色
  /// - Parameter titleColor: 标题颜色
  /// - Parameter backColor: 背景颜色
  /// - Parameter borderColor: 背景边框颜色
  /// - Parameter radius: 圆角
  /// - Parameter state: 状态
  func setBtnColor(titleColor: UIColor,
                   backColor: UIColor,
                   borderColor: UIColor?,
                   radius: CGFloat,
                   for state: State) {
    let image = UIImage.from(color: backColor,
                             borderColor: borderColor,
                             borderWidth: 1.5,
                             radius: radius)
    
    self.setBackgroundImage(image, for: state)
    self.setTitleColor(titleColor, for: state)
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = true;
  }
  
  /// 用两个颜色生成的渐变图片作为按钮背景，设置标题颜色
  /// - Parameter titleColor: 标题颜色
  /// - Parameter backLeft: 渐变左侧
  /// - Parameter backRight: 渐变右侧
  /// - Parameter radius: 圆角
  /// - Parameter state: 状态
  func setBtnColor(titleColor: UIColor,
                   backLeft: UIColor,
                   backRight: UIColor,
                   radius: CGFloat,
                   for state: State) {
    let image = UIImage.gradient(size: CGSize(width: 4, height: 2),
                                 colors: [backLeft, backRight],
                                 locations: [0.0, 1],
                                 angle: 1.5)
    
    self.setBackgroundImage(image, for: state)
    self.setTitleColor(titleColor, for: state)
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = true;
  }
  
}
