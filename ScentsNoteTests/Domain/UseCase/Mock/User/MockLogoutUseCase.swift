//
//  MockLogoutUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

@testable import ScentsNote_Dev

final class MockLogoutUseCase: LogoutUseCase {
  
  var executeCalledCount = 0
  
  func execute() {
    self.executeCalledCount += 1
  }
}
