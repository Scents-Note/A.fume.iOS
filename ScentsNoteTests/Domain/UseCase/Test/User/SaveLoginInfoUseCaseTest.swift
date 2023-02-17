//
//  SaveLoginInfoUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
@testable import ScentsNote_Dev

final class SaveLoginInfoUseCaseTest: XCTestCase {
  
  private var saveLoginInfoUseCase: SaveLoginInfoUseCase!
  
  override func setUpWithError() throws {
    self.saveLoginInfoUseCase = DefaultSaveLoginInfoUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.saveLoginInfoUseCase = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let loginInfo = LoginInfo(userIdx: 0, token: "", refreshToken: "")
    let email = "test@scentsnote.com"
    let password = "test"
    
    // When
    self.saveLoginInfoUseCase.execute(loginInfo: loginInfo, email: email, password: password)
    
    // Then
    XCTAssert(true)
  }
}
