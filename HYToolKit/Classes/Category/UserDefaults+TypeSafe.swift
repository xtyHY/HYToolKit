//
//  UserDefaults+TypeSafe.swift
//  HYToolKit
//
//  Created by HY on 2019/10/30.
//  Copyright © 2019 HY. All rights reserved.
//
//  From: https://danieltull.co.uk//blog/2019/10/09/type-safe-user-defaults/

/**
  -----Example------
 
  extension UserDefaults.Key where ValueType == Int {
    static let myCount = UserDefaults.Key<Int>("myCount")
  }
 
  func doSome() {
    UserDefaults.standard.set(11, for: .myCount)
    _ = UserDefaults.standard.value(for: .myCount) ?? 0
    UserDefaults.standard.removeValue(for: .myCount)
  }
*/

import UIKit

extension UserDefaults {
  public struct Key<ValueType> {
    fileprivate let name: String
    public init(_ name: String) {
      self.name = name
    }
  }
  
  public func set<ValueType>(_ value: ValueType?, for key: Key<ValueType>) {
    set(value, forKey: key.name)
  }
  
  public func value<ValueType>(for key: Key<ValueType>) -> ValueType? {
    return value(forKey: key.name) as? ValueType
  }
  
  public func removeValue<ValueType>(for key: Key<ValueType>) {
    removeObject(forKey: key.name)
  }
}
