//
//  MockChangePasswordCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

@testable import ScentsNote

final class MockChangePasswordCoordinator: ChangePasswordCoordinator {
  
  var finishFlowCalledCount = 0
  
  var finishFlow: (() -> Void)?
  
  init() {
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
  }
}
