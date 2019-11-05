//
//  FileManager+Tool.swift
//  HYToolKit
//
//  Created by HY on 2019/10/31.
//  Copyright © 2019 HY. All rights reserved.
//

import Foundation

public extension FileManager {
  
  // MARK: - Caculate Size
  /// 计算单文件大小(单位b)
  /// - Parameter path: 文件路径
  class func fileSize(at path: String) -> FileSizeEnum {
    do {
      let info = try FileManager.default.attributesOfItem(atPath: path)
      let size = info[.size] as? UInt ?? 0
      return .Byte(size)
    } catch {
      print("[\(error)] at: \(path)")
      return .Byte(0)
    }
  }
  
  /// 遍历path下所有文件(+子文件夹下)的大小(单位m)
  /// - Parameter path: 目录路径
  class func foldSize(in path: String) -> FileSizeEnum {
    guard let url = URL(string: path) else { return .MB(0) }
    var size: UInt = 0
    if let enumrator = FileManager.default.enumerator(atPath: path) {
      for obj in enumrator {
        let name = obj as? String ?? ""
        let subpath = url.appendingPathComponent(name)
        size += Self.fileSize(at: subpath.absoluteString).byteValue
      }
    }
    return .MB(FileSizeEnum.Byte(size).mbValue)
  }
  
  /// 无论path是 文件路径 还是 目录路径，尽管扔过来，告诉你有.多.大😋
  /// - Parameter path: 任意路径
  class func size(at path: String) -> FileSizeEnum {
    var isDirectory = ObjCBool(false)
    if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) { return .MB(0) }
    if isDirectory.boolValue {
      return Self.foldSize(in: path)
    } else {
      let size = Self.fileSize(at: path).mbValue
      return .MB(size)
    }
  }
  
  /// 给我一梭子path，还你总计大小
  /// - Parameter paths: 任意路径数组
  class func size(at paths: [String]) -> FileSizeEnum {
    var size: Double = 0.0
    for path in paths {
      size += Self.size(at: path).mbValue
    }
    return .MB(size)
  }
  
  // MARK: - Delete
  /// 批量删除文件/目录
  /// - Parameter paths: 文件/目录路径数组
  class func deleteFile(_ paths: [String], completion: ( (_ success: Int, _ faliure: Int) -> Void)? = nil) -> Void {
    
    var sucCount = 0, failCount = 0
    for path in paths {
      Self.deleteFile(path) ? (sucCount += 1) : (failCount += 1)
    }
    completion?(sucCount, failCount)
  }
  
  /// 删除一个文件/目录
  /// - Parameter path: 文件/目录路径
  class func deleteFile(_ path: String) -> Bool {
    do {
      try FileManager.default.removeItem(atPath: path)
      print("[Delete-Done]: \(path)")
      return true
    } catch {
      print("[Delete-Error][\(error)]: \(path)")
      return false
    }
  }
}
