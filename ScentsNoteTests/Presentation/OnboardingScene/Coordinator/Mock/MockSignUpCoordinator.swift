//
//  MockSignUpCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/17.
//

import Foundation
@testable import ScentsNote_Dev

final class MockSignUpCoordinator: SignUpCoordinator {

  var finishFlowCalledCount = 0
  var showSignUpInformationViewControllerCalledCount = 0
  var showSignUpPasswordViewControllerCalledCount = 0
  var showSignUpGenderViewControllerCalledCount = 0
  var showSignUpBirthViewControllerCalledCount = 0
  var showBirthPopupViewControllerCalledCount = 0
  var hideBirthPopupViewControllerCalledCount = 0
  var startCalledCount = 0
  var startWithTypeCalledCount = 0
  
  
  var finishFlow: (() -> Void)?
  
  init() {
    self.finishFlow = {
      self.finishFlowCalledCount += 1
    }
  }
  
  func showSignUpInformationViewController() {
    
  }
  
  func showSignUpPasswordViewController(with signUpInfo: SignUpInfo) {
    self.showSignUpPasswordViewControllerCalledCount += 1
  }
  
  func showSignUpGenderViewController(with signUpInfo: SignUpInfo?) {
    self.showSignUpGenderViewControllerCalledCount += 1
  }
  
  func showSignUpBirthViewController(with signUpInfo: SignUpInfo?) {
    self.showSignUpBirthViewControllerCalledCount += 1
  }
  
  func showBirthPopupViewController(with birth: Int?) {
    self.showBirthPopupViewControllerCalledCount += 1
  }
  
  func hideBirthPopupViewController() {
  }
  
  func start() {
    
  }
  
  func start(from: CoordinatorType) {
  }
  
  
  
}

