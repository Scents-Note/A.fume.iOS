//
//  EditUserInfo.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import Foundation

struct EditUserInfo {
  let nickname: String
  let gender: String
  let birth: Int
  
  static let `default` = EditUserInfo(nickname: "", gender: "", birth: 0)
}

extension EditUserInfo {
  func toEntity() -> EditUserInfoRequestDTO {
    EditUserInfoRequestDTO(email: nil, nickname: nickname, gender: gender, birth: birth, grade: "USER")
  }
}
