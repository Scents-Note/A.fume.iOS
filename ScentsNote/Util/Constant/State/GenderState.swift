//
//  GenderState.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import Foundation

enum GenderState: Equatable {
  case man
  case woman
  case none
  
  var description: String {
    switch self {
    case .man:
      return "MAN"
    case .woman:
      return "WOMAN"
    case .none:
      return ""
    }
  }
}
