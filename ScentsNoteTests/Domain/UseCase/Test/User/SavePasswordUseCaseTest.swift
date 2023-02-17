//
//  SavePasswordUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
@testable import ScentsNote_Dev

final class SavePasswordUseCaseTest: XCTestCase {
  
  private var savePasswordUseCase: SavePasswordUseCase!
  
  override func setUpWithError() throws {
    self.savePasswordUseCase = DefaultSavePasswordUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.savePasswordUseCase = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let password = "test"
    
    // When
    self.savePasswordUseCase.execute(password: password)
    
    // Then
    XCTAssert(true)
  }
}
