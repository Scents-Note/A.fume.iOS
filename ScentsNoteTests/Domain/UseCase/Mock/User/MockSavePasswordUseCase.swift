//
//  MockSavePasswordUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

@testable import ScentsNote

final class MockSavePasswordUseCase: SavePasswordUseCase {
  
  var executeCalledCount = 0
  
  func execute(password: String) {
    self.executeCalledCount += 1
  }
}
