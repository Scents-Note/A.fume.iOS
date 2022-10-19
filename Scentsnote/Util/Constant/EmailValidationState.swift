//
//  EmailValidationState.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation

enum EmailValidationState: Equatable {
  case empty
  case wrongFormat
  case duplicate
  case success
}
