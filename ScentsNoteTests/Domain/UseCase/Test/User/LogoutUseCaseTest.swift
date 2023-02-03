//
//  LogoutUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
@testable import ScentsNote

final class LogoutUseCaseTest: XCTestCase {
  
  private var logoutUseCase: LogoutUseCase!
  
  override func setUpWithError() throws {
    self.logoutUseCase = DefaultLogoutUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.logoutUseCase = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // When
    self.logoutUseCase.execute()
    
    // Then
    XCTAssert(true)
  }
}
