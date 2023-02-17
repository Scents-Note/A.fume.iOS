//
//  MockLoginCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/16.
//

import Foundation
@testable import ScentsNote_Dev

final class MockLoginCoordinator: LoginCoordinator {
  var finishFlowCalledCount = 0
  var runSignUpFlowCalledCount = 0
  var showLoginViewControllerCalledCount = 0
  
  var finishFlow: (() -> Void)?
  var runSignUpFlow: (() -> Void)?
  
  init() {
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
    
    self.runSignUpFlow = { [weak self] in
      self?.runSignUpFlowCalledCount += 1
    }
  }
  
  func showLoginViewController() {
    self.showLoginViewControllerCalledCount += 1
  }
  
}
