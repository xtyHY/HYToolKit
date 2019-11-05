//
//  Bundle+Info.swift
//  HYToolKit
//
//  Created by HY on 2019/9/25.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

public extension Bundle {
  static var appBundleId: String {
    return main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
  }
  
  static var appVersion: String {
    return main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }
  
  static var appBuildVer: String {
    return main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
  }
  
  static var appName: String {
    return main.object(forInfoDictionaryKey: "CFBundleName") as! String
  }
}
