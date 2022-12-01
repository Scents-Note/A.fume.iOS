//
//  UserInfoResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

struct UserInfoResponseDTO: Decodable {
  let userIdx: Int
  let nickname: String
  let gender: String
  let email: String
  let birth: Int
}

extension UserInfoResponseDTO {
  func toDomain() -> UserInfo {
    UserInfo(nickname: nickname,
             gender: gender,
             birth: birth)
  }
}
