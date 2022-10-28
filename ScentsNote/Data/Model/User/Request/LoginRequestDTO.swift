//
//  LoginRequestDto.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation

struct LoginRequestDTO: Codable {
  private var email: String
  private var password: String
  
  init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}
