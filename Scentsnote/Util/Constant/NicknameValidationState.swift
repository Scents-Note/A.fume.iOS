//
//  NicknameValidationState.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation

enum NicknameValidationState: Equatable {
  case empty
  case containSpecialCharacters
  case duplicate
  case success
}
