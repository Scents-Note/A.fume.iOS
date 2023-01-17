//
//  LoginInfo.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/15.
//

import Foundation

struct LoginInfo: Equatable {
  var userIdx: Int
  var nickname: String?
  var gender: String?
  var birth: Int?
  var token: String
  var refreshToken: String
  
  static let `default` = LoginInfo(userIdx: 0, token: "", refreshToken: "")
}
