//
//  MockFetchUserDefaultUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

@testable import ScentsNote_Dev

final class MockFetchUserDefaultUseCase: FetchUserDefaultUseCase {
  
  var gender = "MAN"
  var nickname = "득연"
  var birth = 1995
  var isLoggedIn = true
  
  func execute<T>(key: String) -> T? {
    switch key {
    case UserDefaultKey.gender:
      return gender as? T
    case UserDefaultKey.nickname:
      return nickname as? T
    case UserDefaultKey.birth:
      return birth as? T
    case UserDefaultKey.isLoggedIn:
      return isLoggedIn as? T
    default:
      return nil
    }
  }
  
//  func updateMock(_ mockString: String) {
//    self.mockString = mockString
//  }
//
//  func updateMock(_ mockBool: Bool) {
//    self.mockBool = mockBool
//  }
//
//  func updateMock(_ mockInt: Int) {
//    self.mockInt = mockInt
//  }
  
  
}
