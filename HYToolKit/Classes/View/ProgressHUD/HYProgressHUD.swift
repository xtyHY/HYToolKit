//
//  HYProgressHUD.swift
//  HYToolKit
//
//  Created by HY on 2019/10/18.
//  Copyright © 2019 HY. All rights reserved.
//

import Foundation
import MBProgressHUD

/// 用来寸所有的hud对象，最后hideAll的时候使用，MBProgressHUD是这么推荐的
private var allHuds: [HYProgressHUD] = []

public class HYProgressHUD: Equatable {
  
  /// 样式枚举
  public enum Style {
    case normal // HUD (+ text)
    case text // Only text
    case completion // check icon (+ text)
    case error // wrong icon (+ text)
  }
  
  // MARK: property
  /// 控制是否是白色样式, 默认false
  static var lightAppearce: Bool = false
  private static var window: UIWindow? = findWindow()
  
  private var style: Style = .normal
  private var text: String?
  private lazy var hud: MBProgressHUD = HYProgressHUD.createHud()
  
  /// 初始化hud
  /// - Parameter style: 样式
  /// - Parameter text: 文字
  public init?(_ style: Style, text: String? = nil) {
    guard let window = HYProgressHUD.window else {
      return nil
    }
    allHuds.append(self)
    
    self.hud.removeFromSuperViewOnHide = true
    self.change(style, text: text)
    
    DispatchQueue.main.async {
      window.addSubview(self.hud)
      window.bringSubviewToFront(self.hud)
    }
  }
  
  /// Equatable
  public static func == (lhs: HYProgressHUD, rhs: HYProgressHUD) -> Bool {
    return lhs === rhs
  }
  
}

// MARK: Private
private extension HYProgressHUD {

  /// 创建MBProgressHUD
  class func createHud() -> MBProgressHUD {
    if let window = Self.window {
      return MBProgressHUD(view: window)
    }
    return MBProgressHUD(frame: UIScreen.main.bounds)
  }
  
  /// 找到放置的window
  class func findWindow() -> UIWindow? {
    if let window = UIApplication.shared.keyWindow,
      window.isMember(of: UIWindow.self) {
      return window
    }
    // 获取最上面一个window，防止keywindow为空的时候
    for window in UIApplication.shared.windows.reversed() {
      if window.isMember(of: UIWindow.self) { return window }
    }
    return nil
  }
  
}

// MARK: Public
public extension HYProgressHUD {
  
  /// 变换成别的样式
  /// - Parameter style: 样式
  /// - Parameter text: 文字
  /// - Parameter hide: 自动隐藏
  func change(_ style: Style, text: String? = nil, hide: Bool = false) {
    self.style = style
    self.text = text
    
    self.hud.detailsLabel.text = text
    self.hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
    
    switch style {
    case .normal:
      self.hud.mode = .indeterminate
    case .text:
      self.hud.mode = .text
    case .completion:
      self.hud.mode = .customView
      self.hud.customView = UIImageView(image: UIImage(named: "checkmark", in: Bundle(for: Self.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
    case .error:
      self.hud.mode = .customView
      self.hud.customView = UIImageView(image: UIImage(named: "crossmark", in: Bundle(for: Self.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
    }
    
    if HYProgressHUD.lightAppearce {
      self.hud.bezelView.style = .blur
      self.hud.bezelView.backgroundColor = .black(alpha: 0.1)
      self.hud.contentColor = .black
      self.hud.customView?.tintColor = .black(alpha: 0.7)
    } else {
      self.hud.bezelView.backgroundColor = .black(alpha: 0.8)
      self.hud.contentColor = .white
      self.hud.customView?.tintColor = .white
    }
    
    if hide { self.hide(2) }
  }
  
  /// 手动显示hud
  func show() {
    DispatchQueue.main.async {
      self.hud.show(animated: true)
    }
  }
  
  /// 手动隐藏hud
  /// - Parameter after: 延迟多少秒，默认0
  func hide(_ after: Int = 0) {
    let time = after > 0 ? after : 0
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
      if let index = allHuds.firstIndex(of: self) {
        allHuds.remove(at: index)
      }
      self.hud.removeFromSuperview()
      self.hud.hide(animated: true)
    }
  }
  
  /// 直接显示并在2秒后隐藏
  /// - Parameter style: 样式
  /// - Parameter text: 文字
  class func show(_ style: Style = .normal, text: String? = nil) {
    let mHud = HYProgressHUD(style, text: text)
    mHud?.show()
    mHud?.hide(2)
  }
  
  /// 显示文字型hud
  /// - Parameter text: 文字
  class func showText(_ text: String) {
    self.show(.text, text: text)
  }
  
  /// 显示带一个✖️的hud
  /// - Parameter text: 文字
  class func showError(_ text: String?) {
    self.show(.error, text: text)
  }
  
  /// 显示带一个✔️的hud
  /// - Parameter text: 文字
  class func showCompletion(_ text: String?) {
    self.show(.completion, text: text)
  }
  
  /// 隐藏所有hud
  class func hideAll() {
    for hud in allHuds { hud.hide() }
  }
  
}
