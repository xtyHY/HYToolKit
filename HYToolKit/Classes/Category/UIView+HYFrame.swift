//
//  UIView+HYFrame.swift
//  HYToolKit
//
//  Created by HY on 2019/9/27.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

extension UIView {
  // MARK: - Frame Origin
  
  public var x: CGFloat {
    get { return self.frame.origin.x }
    set {
      var rect = self.frame
      rect.origin.x = newValue
      self.frame = rect
    }
  }
  
  public var y: CGFloat {
    get { return self.frame.origin.y }
    set {
      var rect = self.frame
      rect.origin.y = newValue
      self.frame = rect
    }
  }

  // MARK: - Frame Size
  
  public var width: CGFloat {
    get { return self.frame.size.width }
    set {
      var rect = self.frame
      rect.size.width = newValue
      self.frame = rect
    }
  }
  
  public var height: CGFloat {
    get { return self.frame.size.height }
    set {
      var rect = self.frame
      rect.size.height = newValue
      self.frame = rect
    }
  }
  
  // MARK: - Border
  
  public var left: CGFloat {
    get { return self.x }
    set { self.x = newValue }
  }
  
  public var top: CGFloat {
    get { return self.y }
    set { self.y = newValue }
  }
  
  public var bottom: CGFloat {
    get { return self.y + self.height }
    set { self.y = newValue - self.height }
  }
  
  public var right: CGFloat {
    get { return self.x + self.width }
    set { self.x = newValue - self.width }
  }
  
  // MARK: - Center
  
  public var centerX: CGFloat {
    get { return self.center.x }
    set { self.center = CGPoint(x: newValue, y: self.centerY) }
  }
  
  public var centerY: CGFloat {
    get { return self.center.y }
    set { self.center = CGPoint(x: self.centerX, y: newValue) }
  }
}
