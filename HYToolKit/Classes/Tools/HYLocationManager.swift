//
//  HYLocationManager.swift
//  HYToolKit
//
//  Created by HY on 2019/10/24.
//  Copyright © 2019 HY. All rights reserved.
//

import Foundation
import CoreLocation

public typealias HYLocationResult = ((_ locations: [CLLocation], _ error: Error?) -> Void)
public typealias HYPlacemarkResult = ((_ placemarks: [CLPlacemark], _ error: Error?) -> Void)

@objc public class HYLocationManager: NSObject, CLLocationManagerDelegate {
  public static let shared = HYLocationManager.init()
  
  @objc private let locationManager = CLLocationManager()
  private var locRes: HYLocationResult?
  private var placeRes: HYPlacemarkResult?
  
  // MARK: Init
  override init() {
    super.init()
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  // MARK: Private
  private func _start(location: HYLocationResult?, placemark: HYPlacemarkResult?) {
    self.locRes = location
    self.placeRes = placemark
    self.locationManager.startUpdatingLocation()
  }
  
  // MARK:  CLLocationManagerDelegate
  /// 收到定位回调
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    manager.stopUpdatingLocation()
    
    // location 回调
    self.locRes?(locations, nil)
    
    // placemark 回调
    if self.placeRes == nil { return }
    
    guard let loc = locations.first else {
      self.placeRes?([], CLError(.locationUnknown))
      return
    }
    
    CLGeocoder().reverseGeocodeLocation(loc) {[weak self] (placemarks, error) in
      self?.placeRes?(placemarks ?? [], error)
    }
  }
  
  /// 定位失败回调
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    manager.stopUpdatingLocation()
    
    self.locRes?([], error)
    self.placeRes?([], error)
  }
  
  /// 授权失败
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .notDetermined {
      print("地理位置-等待用户授权")
    } else if (status == .authorizedAlways || status == .authorizedWhenInUse) {
      print("地理位置-授权成功")
    } else {
      print("地理位置-授权失败")
    }
  }
  
}

// MARK: - Public
public extension HYLocationManager {
  
  /// 启动定位，回调是CLLocation数组
  /// - Parameter location: 回调
  func fetchLocation(_ callback: @escaping HYLocationResult) {
    self._start(location: callback, placemark: nil)
  }
  
  /// 启动定位，回调是CLPlacemark数组
  /// - Parameter placemark: 回调
  func fetchPlacemark(_ callback: @escaping HYPlacemarkResult) {
    self._start(location: nil, placemark: callback)
  }
  
  /// 查一下是不是没有定位权限
  class func locatedAuth() -> Error? {
    if CLLocationManager.locationServicesEnabled() == false {
      return CLError(.denied, userInfo: [NSLocalizedDescriptionKey: "获取定位信息失败，请前往设置开启定位服务"])
    }
    
    let status = CLLocationManager.authorizationStatus()
    if status != .authorizedAlways,
      status != .authorizedWhenInUse,
      status != .notDetermined {
      let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
      let msg = "获取定位信息失败，请到 设置-\(name ?? "AppName")-位置 允许访问位置信息"
      return CLError(.denied, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    return nil
  }
}

// MARK: - Tool
public extension HYLocationManager {
  
  /// placemark的省
  class func province(by placemark: CLPlacemark) -> String {
    return placemark.administrativeArea ?? ""
  }
  
  /// placemark的市（直辖市也返回）
  class func city(by placemark: CLPlacemark) -> String {
    guard let city = placemark.locality else {
      // 直辖市，城市名称用省名称问题
      return placemark.administrativeArea ?? ""
    }
    return city
  }
  
  /// placemark的地址
  class func address(by placemark: CLPlacemark) -> String {
    if let origDict = placemark.addressDictionary,
      let addr = origDict["FormattedAddressLines"] as? String {
      return addr
    }
    
    let addr = "\(placemark.country ?? "") \(placemark.administrativeArea ?? "") \(placemark.locality ?? "") \(placemark.subLocality ?? "") \(placemark.name ?? "")"
    return addr
  }
}
