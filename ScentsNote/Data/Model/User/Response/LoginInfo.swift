//
//  LoginResponseDto.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//

import Foundation

struct LoginInfo: Decodable {
  var userIdx: Int
  var nickname: String?
  var gender: String?
  var birth: Int?
  var token: String
  var refreshToken: String
}
