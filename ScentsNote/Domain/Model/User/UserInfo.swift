//
//  UserInfo.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import Foundation

struct UserInfo {
  let nickname: String
  let gender: String
  let birth: Int
  
  static let `default` = UserInfo(nickname: "", gender: "", birth: 0)
}

extension UserInfo {
  func toEntity() -> UserInfoRequestDTO {
    UserInfoRequestDTO(email: nil, nickname: nickname, gender: gender, birth: birth, grade: "USER")
  }
}
