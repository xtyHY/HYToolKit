//
//  Bundle+Info.swift
//  HYToolKit
//
//  Created by HY on 2019/9/25.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

extension Bundle {
  static public var appBundleId: String {
    return main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
  }
  
  static public var appVersion: String {
    return main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }
  
  static public var appBuildVer: String {
    return main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
  }
  
  static public var appName: String {
    return main.object(forInfoDictionaryKey: "CFBundleName") as! String
  }
}
