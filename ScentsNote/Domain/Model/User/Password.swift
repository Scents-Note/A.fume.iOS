//
//  Password.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import Foundation

struct Password {
  let oldPassword: String
  let newPassword: String
}

extension Password {
  func toEntity() -> PasswordRequestDTO {
    PasswordRequestDTO(prevPassword: self.oldPassword, newPassword: self.newPassword)
  }
}
