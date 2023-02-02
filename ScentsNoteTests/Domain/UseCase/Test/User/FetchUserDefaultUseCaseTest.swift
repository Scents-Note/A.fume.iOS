//
//  FetchUserDefaultUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
@testable import ScentsNote

final class FetchUserDefaultUseCaseTest: XCTestCase {
  
  private var fetchUserDefaultUseCase: FetchUserDefaultUseCase!
  
  override func setUpWithError() throws {
    self.fetchUserDefaultUseCase = DefaultFetchUserDefaultUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.fetchUserDefaultUseCase = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let key = "nickname"
    let expect = "test"
    
    // When
    let actual: String? = self.fetchUserDefaultUseCase.execute(key: key)
    
    // Then
    XCTAssertEqual(actual, expect)
  }
}
