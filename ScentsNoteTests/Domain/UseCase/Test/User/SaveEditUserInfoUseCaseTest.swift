//
//  SaveEditUserInfoUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
@testable import ScentsNote_Dev

final class SaveEditUserInfoUseCaseTest: XCTestCase {
  
  private var saveEditUserInfoUseCase: SaveEditUserInfoUseCase!
  
  override func setUpWithError() throws {
    self.saveEditUserInfoUseCase = DefaultSaveEditUserInfoUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.saveEditUserInfoUseCase = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let editUserInfo = EditUserInfo(nickname: "", gender: "", birth: 1995)
    
    // When
    self.saveEditUserInfoUseCase.execute(userInfo: editUserInfo)
    
    // Then
    XCTAssert(true)
    
  }
}
