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
      ? "https://api-dev.scentsnote.co.kr" : "https://api-prd1.scentsnote.co.kr"
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
