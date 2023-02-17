//
//  MockEditInformationCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

@testable import ScentsNote_Dev

final class MockEditInformationCoordinator: EditInformationCoordinator {
  
  var finishFlowCalledCount = 0
  var showWebViewControllerCalledCount = 0
  var showBirthPopupViewControllerCalledCount = 0
  var hideBirthPopupViewControllerCalledCount = 0
  
  var finishFlow: (() -> Void)?
  
  init() {
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
  }
  
  func showWebViewController(with url: String) {
    self.showWebViewControllerCalledCount += 1
  }
  
  func showBirthPopupViewController(with birth: Int?) {
    self.showBirthPopupViewControllerCalledCount += 1
  }
  
  func hideBirthPopupViewController() {
    self.hideBirthPopupViewControllerCalledCount += 1
  }
  
  func start() {}
  
  func start(from: CoordinatorType) {}
  
}
