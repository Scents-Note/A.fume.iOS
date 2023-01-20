//
//  MockSaveEditUserInfoUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import RxSwift
@testable import ScentsNote

final class MockSaveEditUserInfoUseCase: SaveEditUserInfoUseCase {
  
  var executeCalledCount = 0
  
  func execute(userInfo: EditUserInfo) {
    self.executeCalledCount += 1
  }
}
