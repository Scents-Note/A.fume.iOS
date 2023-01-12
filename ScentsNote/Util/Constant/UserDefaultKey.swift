//
//  UserDefaultKey.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//


enum UserDefaultKey {
  static let token = "token"
  static let refreshToken = "refreshToken"
  static let nickname = "nickname"
  static let userIdx = "userIdx"
  static let gender = "gender"
  static let birth = "birth"
  static let isLoggedIn = "isLoggedIn"
  static let email = "email"
  static let password = "password"
  
  // 로그아웃 시 모두 삭제하기 위한 list
  static let list: [UserDefaultKey] = [.token, .refreshToken, nickname, .userIdx, gender, birth, isLoggedIn, email, password]
}
