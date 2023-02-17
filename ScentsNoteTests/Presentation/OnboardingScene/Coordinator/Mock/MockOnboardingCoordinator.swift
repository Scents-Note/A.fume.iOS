//
//  MockOnboardingCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/17.
//

import Foundation
@testable import ScentsNote_Dev

final class MockOnboardingCoordinator: OnboardingCoordinator {
  
  var runLoginFlowCalledCount = 0
  var runSignUpFlowCalledCount = 0
  
  func runLoginFlow() {
    self.runLoginFlowCalledCount += 1
  }
  
  func runSignUpFlow() {
    self.runSignUpFlowCalledCount += 1
  }
  
  
}
