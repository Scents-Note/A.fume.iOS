//
//  Menu.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

enum Menu: Int, Equatable {
  case updateInfo
  case changePW
  case report
  case inquire
  case logout
  case login
  
  static let loggedIn: [Menu] = [.updateInfo, .changePW, .report, .inquire, .logout]
  static let loggedOut: [Menu] = [.login]
  
  var description: String {
    switch self {
    case .updateInfo:
      return "내정보 수정"
    case .changePW:
      return "비밀번호 변경"
    case .report:
      return "향수 및 브랜드 제보하기"
    case .inquire:
      return "문의하기"
    case .logout:
      return "로그아웃"
    case .login:
      return "로그인 후 사용해주세요"
    }
  }
}
