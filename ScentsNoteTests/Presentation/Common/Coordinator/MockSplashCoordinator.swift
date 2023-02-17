//
//  MockSplashCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

@testable import ScentsNote_Dev

final class MockSplashCoordinator: SplashCoordinator {
  var finishFlowCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
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
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
}
