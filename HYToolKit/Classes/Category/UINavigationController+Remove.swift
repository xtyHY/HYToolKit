//
//  UINavigationController+Remove.swift
//  HYToolKit
//
//  Created by HY on 2019/10/29.
//  Copyright © 2019 HY. All rights reserved.
//

import UIKit

public extension UINavigationController {
  func remove(classes: [UIViewController.Type]) -> Void {
    let result = self.viewControllers.filter { (vc) -> Bool in
      for cls in classes {
        if vc.isKind(of: cls.self) { return false }
      }
      return true
    }
    self.navigationController?.viewControllers = result
  }
}
