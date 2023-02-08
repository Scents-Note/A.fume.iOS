//
//  Config.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//

import Foundation

enum AppConfiguration {
  case debug
  case release
}

struct Config {
  enum Network {
    static var baseURL: String {
      return Config.appConfiguration == .debug
      ? "http://13.124.104.53:3001/A.fume/api/0.0.1" : "http://13.124.104.53:8082/A.fume/api/0.0.1"
    }
  }
  static var isDebug: Bool {
#if DEBUG
    return true
#else
    return false
#endif
  }
  
  static var appConfiguration: AppConfiguration {
    if isDebug {
      return .debug
    } else {
      return .release
    }
  }
}
