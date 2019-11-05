//
//  UIImage+CreateByColor.swift
//  HYToolKit
//
//  Created by HY on 2019/9/25.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

private func EdgeSizeFromRadius(_ radius: CGFloat) -> CGFloat {
  return (radius * 2 + 1)
}

public extension UIImage {
  
  /// 用颜色创建一个长方形图片
  /// - Parameter color: 颜色
  /// - Parameter radius: 圆角，默认0
  /// - Parameter borderWidth: 边框宽度，默认0
  /// - Parameter borderColor: 边框颜色，可不传
  static func from(color: UIColor,
                          borderColor: UIColor? = nil,
                          borderWidth: CGFloat = 0,
                          radius: CGFloat = 0) -> UIImage {
    
    let minEdgeSize = EdgeSizeFromRadius(radius)
    let rect = CGRect(x: 0, y: 0, width: minEdgeSize, height: minEdgeSize)
    let path = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
    path.lineWidth = borderColor != nil ? borderWidth : 0
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    if let bColor = borderColor, borderWidth>0 {
      bColor.setStroke()
    }
    path.fill()
    path.stroke()
    path.addClip()
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return (image ?? self.init()).resizableImage(withCapInsets: UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius))
  }
  
  /// 创建一个渐变的图片
  /// - Parameter size: 大小
  /// - Parameter colors: 颜色数组
  /// - Parameter locations: 位置信息数组
  /// - Parameter angle: 角度
  static func gradient(size: CGSize, colors: [UIColor], locations: [CGFloat], angle: CGFloat = 0) -> UIImage {
    
    var colorComponents: [CGFloat] = [];
    
    for color in colors {
      var r = CGFloat.zero, g = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
      color.getRed(&r, green: &g, blue: &b, alpha: &a)
      colorComponents.append(contentsOf: [r, g, b, a])
    }
    
    UIGraphicsBeginImageContext(size);
    
    let ctx = UIGraphicsGetCurrentContext()!;
    let colorSpace = ctx.colorSpace!;
    let locations : [CGFloat] = locations;
    let gradient : CGGradient = CGGradient.init(
      colorSpace: colorSpace,
      colorComponents: colorComponents,
      locations: locations,
      count: locations.count
    )!;
    
    // 默认 angle 0
    var startPoint = CGPoint(x: size.width/2, y: 0)
    var endPoint   = CGPoint(x: size.width/2, y: size.height)
    if (angle == 0.5) {
      startPoint = CGPoint(x: size.width, y: size.height/2)
      endPoint   = CGPoint(x: 0, y: size.height/2)
    } else if (angle == 1.0) {
      startPoint = CGPoint(x: size.width/2, y: size.height)
      endPoint   = CGPoint(x: size.width/2, y: 0)
    } else if (angle == 1.5) {
      startPoint = CGPoint(x: 0, y: size.height/2)
      endPoint   = CGPoint(x: size.width, y: size.height/2)
    }
    ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsAfterEndLocation)
    
    let image = UIGraphicsGetImageFromCurrentImageContext();
    return image ?? self.init()
  }
  
  /// 使用 color+size 创建一个椭圆/圆形图片
  /// - Parameter color: 颜色
  /// - Parameter size: 图片大小
  static func circularImage(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let path = UIBezierPath.init(ovalIn: rect)
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    color.setStroke()
    path.addClip()
    path.fill()
    path.stroke()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image ?? self.init()
  }
  
  /// 重新改变图片尺寸
  /// - Parameter size: 尺寸
  func reset(size: CGSize) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    self.draw(in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  /// 等比缩放
  /// - Parameter fixWith: 固定width
  func scale(fixWith: CGFloat) -> UIImage? {
    let fixScale = fixWith/self.size.width
    
    let size = CGSize(width: fixWith, height: self.size.height * fixScale)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
  /// 等比缩放
  /// - Parameter fixWith: 固定height
  func scale(fixHeight: CGFloat) -> UIImage? {
    let fixScale = fixHeight/self.size.height
    
    let size = CGSize(width: self.size.width * fixScale, height: fixHeight)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}
