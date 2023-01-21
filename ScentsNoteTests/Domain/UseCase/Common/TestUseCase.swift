//
//  TestUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

@testable import ScentsNote

class TestUseCase {
  
  var state: ResponseState = .success
  let error: Error = NetworkError.restError(statusCode: 401, description: "테스트 에러")

  func setState(state: ResponseState) {
    self.state = state
  }
}
