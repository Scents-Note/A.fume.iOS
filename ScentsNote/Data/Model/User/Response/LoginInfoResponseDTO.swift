//
//  LoginInfoResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//

import Foundation

struct LoginInfoResponseDTO: Decodable {
  var userIdx: Int
  var nickname: String?
  var gender: String?
  var birth: Int?
  var token: String
  var refreshToken: String
}

extension LoginInfoResponseDTO {
  func toDomain() -> LoginInfo {
    LoginInfo(userIdx: self.userIdx,
              nickname: self.nickname,
              gender: self.gender,
              birth: self.birth,
              token: self.token,
              refreshToken: self.refreshToken)
  }
}
