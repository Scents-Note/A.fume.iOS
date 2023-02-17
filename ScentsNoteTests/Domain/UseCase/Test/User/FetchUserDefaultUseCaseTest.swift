//
//  FetchUserDefaultUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
@testable import ScentsNote_Dev

final class FetchUserDefaultUseCaseTest: XCTestCase {
  
  private var fetchUserDefaultUseCase: FetchUserDefaultUseCase!
  
  override func setUpWithError() throws {
    self.fetchUserDefaultUseCase = DefaultFetchUserDefaultUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.fetchUserDefaultUseCase = nil
  }
  
  func testExecute_fetchNickname() throws {
    
    // Given
    let key = "nickname"
    let expect = "득연"
    
    // When
    let actual: String? = self.fetchUserDefaultUseCase.execute(key: key)
    
    // Then
    XCTAssertEqual(actual, expect)
  }
  
  func testExecute_fetchGender() throws {
    
    // Given
    let key = "gender"
    let expect = "MAN"
    
    // When
    let actual: String? = self.fetchUserDefaultUseCase.execute(key: key)
    
    // Then
    XCTAssertEqual(actual, expect)
  }
  
  func testExecute_fetchBirth() throws {
    
    // Given
    let key = "birth"
    let expect = 1995
    
    // When
    let actual: Int? = self.fetchUserDefaultUseCase.execute(key: key)
    
    // Then
    XCTAssertEqual(actual, expect)
  }
  
  
}
