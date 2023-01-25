//
//  MockFetchUserDefaultUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

@testable import ScentsNote

final class MockFetchUserDefaultUseCase: FetchUserDefaultUseCase {
  
  var mockString = "success"
  var mockBool = true
  var mockInt = 1
  
  func execute<T>(key: String) -> T? {
    switch T.self {
    case is String.Type:
      return mockString as? T
    case is Bool.Type:
      return mockBool as? T
    case is Int.Type:
      return mockInt as? T
    default:
      return nil
    }
  }
  
  func updateMock(_ mockString: String) {
    self.mockString = mockString
  }
  
  func updateMock(_ mockBool: Bool) {
    self.mockBool = mockBool
  }
  
  func updateMock(_ mockInt: Int) {
    self.mockInt = mockInt
  }
  
  
}
