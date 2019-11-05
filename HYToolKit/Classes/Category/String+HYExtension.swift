//
//  String+HYExtension.swift
//  HYToolKit
//
//  Created by HY on 2019/9/25.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

public extension String {
  
  /// range 转 nsrange
  func nsRange(from range: Range<String.Index>) -> NSRange {
    guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
      return NSMakeRange(0, 0)
    }
    
    return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from),
                       utf16.distance(from: from, to: to))
  }
  
  /// nsrange 转 range
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
      let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
      let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self)
    else {
      return nil
    }
    return from ..< to
  }
  
  /// jsonString转dictionary
  /// - Parameter jsonString: jsonString
  func convertToDict() -> Dictionary<String, Any> {
    guard let data = self.data(using: .utf8) else {
      return [:]
    }
    
    if let result = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
      return (result as? [String: Any]) ?? [:]
    }
    
    return [:]
  }
}
