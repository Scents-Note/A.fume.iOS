//
//  MockSaveLoginInfoUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/16.
//

import RxSwift
@testable import ScentsNote

final class MockSaveLoginInfoUseCase: SaveLoginInfoUseCase {
  
  var excuteCalledCount = 0
  
  func execute(loginInfo: LoginInfo, email: String?, password: String?) {
    self.excuteCalledCount += 1
  }
  
}
