//
//  EmailValidationState.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation

enum InputState: Equatable {
  case empty
  case editing
  case wrongFormat
  case correctFormat
  case duplicate
  case success
  
  var emailDescription: String {
      switch self {
      case .wrongFormat:
          return "이메일 형식이 맞지 않습니다."
      case .duplicate:
          return "이미 사용 중인 이메일 입니다."
      default:
          return ""
      }
  }
  
  var nicknameDescription: String {
      switch self {
      case .wrongFormat:
          return "특수문자는 사용하실 수 없습니다."
      case .duplicate:
          return "이미 등록된 닉네임입니다."
      default:
          return ""
      }
  }
}
