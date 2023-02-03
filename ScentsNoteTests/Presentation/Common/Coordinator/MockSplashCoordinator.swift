//
//  MockSplashCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

@testable import ScentsNote

final class MockSplashCoordinator: SplashCoordinator {
  
  var finishFlowCalledCount = 0
  var showSplashViewControllerCalledCount = 0
  
  var finishFlow: (() -> Void)?
  
  init() {
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
  }
  
  func showSplashViewController() {
    self.showSplashViewControllerCalledCount += 1
  }
}
