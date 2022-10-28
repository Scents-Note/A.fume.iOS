//
//  SignUpInfo.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
//

import Foundation

struct SignUpInfo: Equatable {
  var password: String?
  var email: String?
  var nickname: String?
  var gender: String?
  var birth: Int?
  var grade: String = "USER"
}
