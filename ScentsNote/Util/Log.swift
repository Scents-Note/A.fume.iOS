//
//  Log.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/11.
//


public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
#if DEBUG
  let filename = filename.split(separator: ".")[0]
  let funcName = funcName.split(separator: "(")[0]
  
  if let obj = object {
    print("Log: \(filename.components(separatedBy: "/").last ?? "") (\(line)) : \(funcName) : \(obj)")
  } else {
    print("Log: \(filename.components(separatedBy: "/").last ?? "") (\(line)) : \(funcName) : nil")
  }
#endif
}
