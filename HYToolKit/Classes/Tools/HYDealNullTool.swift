//
//  HYDealNullTool.swift
//  HYToolKit
//
//  Created by HY on 2019/10/9.
//  Copyright © 2019 HY. All rights reserved.
//

import Foundation

class HYDealNullTool {
  /// 将任意类型中的所有NSNull类型清除，若是NSNull被改成""
  class func deal(_ data: Any) -> Any {
    if (data is [String: Any]) {
      return self.deal(dict: data as! [String : Any])
    } else if (data is [Any]) {
      return self.deal(array: data as! [Any])
    } else if (data is String) {
      return data
    } else if (data is NSNull) {
      return ""
    } else {
      return data
    }
  }
  
  /// 将Dictionary中的NSNull类型清除
  class func deal(dict: [String: Any]) -> [String: Any] {
    var result = dict
    for (key, value) in result {
      result[key] = self.deal(value)
    }
    return result
  }
  
/// 将Array中的NSNull类型清除
  class func deal(array: [Any]) -> [Any] {
    var result = array
    for i in 0..<array.count {
      result[i] = self.deal(result[i])
    }
    return result
  }
}
