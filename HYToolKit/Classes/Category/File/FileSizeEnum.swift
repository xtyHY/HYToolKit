//
//  FileSizeEnum.swift
//  HYToolKit
//
//  Created by HY on 2019/10/31.
//  Copyright © 2019 HY. All rights reserved.
//

import Foundation

public enum FileSizeEnum {
  case Byte(_ value: UInt)
  case KB(_ value: Double)
  case MB(_ value: Double)
  case GB(_ value: Double)

  var byteValue: UInt {
    switch self {
    case .Byte(let value):
      return value
    case .KB(let value):
      return UInt(value * 1024)
    case .MB(let value):
      return UInt(value * 1024 * 1024)
    case .GB(let value):
      return UInt(value * 1024 * 1024 * 1024)
    }
  }
    
  var kbValue: Double {
    switch self {
    case .Byte(let value):
      return Double(value) / 1024.0
    case .KB(let value):
      return value
    case .MB(let value):
      return value * 1024
    case .GB(let value):
      return value * 1024 * 1024
    }
  }
  
  var mbValue: Double {
    switch self {
    case .Byte(let value):
      return Double(value) / (1024.0 * 1024.0)
    case .KB(let value):
      return value / 1024.0
    case .MB(let value):
      return value
    case .GB(let value):
      return value * 1024
    }
  }
  
  var gbValue: Double {
    switch self {
    case .Byte(let value):
      return Double(value) / (1024.0 * 1024.0 * 1024)
    case .KB(let value):
      return value / (1024.0 * 1024.0)
    case .MB(let value):
      return value / 1024.0
    case .GB(let value):
      return value
    }
  }
  
  var description: String {
    switch self {
    case .Byte(let value):
      return "\(value) B"
    case .KB(let value):
      return String(format:"%.2f KB", value)
    case .MB(let value):
      return String(format:"%.2f MB", value)
    case .GB(let value):
      return String(format:"%.2f GB", value)
    }
  }
  
  var perfectDescription: String {
    switch self {
    case .Byte(let value):
      if value > 1024 {
        return Self.KB(self.kbValue).perfectDescription
      }
      return self.description
      
    case .KB(let value):
      if value < 1 {
        return Self.Byte(self.byteValue).perfectDescription
      } else if value > 1024 {
        return Self.MB(self.mbValue).perfectDescription
      }
      return self.description
      
    case .MB(let value):
      if value < 1 {
        return Self.KB(self.kbValue).perfectDescription
      } else if value > 1024 {
        return Self.GB(self.gbValue).perfectDescription
      }
      return self.description
      
    case .GB(let value):
      if value < 1 {
        return Self.MB(self.mbValue).perfectDescription
      }
      return self.description
    }
  }
  
}
