//
//  FetchUserPasswordUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class FetchUserPasswordUseCaseTest: XCTestCase {
  
  private var fetchUserPasswordUseCase: FetchUserPasswordUseCase!
  
  override func setUpWithError() throws {
    self.fetchUserPasswordUseCase = DefaultFetchUserPasswordUseCase(userRepository: MockUserRepository())
  }
  
  override func tearDownWithError() throws {
    self.fetchUserPasswordUseCase = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let expected = "test"
    
    // When
    let actual = self.fetchUserPasswordUseCase.execute()

    // Then
    XCTAssertEqual(actual, expected)
    
  }
}


