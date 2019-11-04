//
//  Enum+EnumeratableEnumType.swift
//  HYToolKit
//
//  Created by HY on 2019/10/20.
//  Copyright © 2019 HY. All rights reserved.
//

import Foundation

protocol EnumeratableEnumType {
  static var allValues: [Self] { get }
}
