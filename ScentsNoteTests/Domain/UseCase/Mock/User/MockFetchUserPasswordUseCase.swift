//
//  MockFetchUserPasswordUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

@testable import ScentsNote

final class MockFetchUserPasswordUseCase: FetchUserPasswordUseCase {
  func execute() -> String {
    return "test"
  }
}
