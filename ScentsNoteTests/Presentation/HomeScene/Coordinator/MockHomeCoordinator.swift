//
//  MockHomeCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/27.
//

@testable import ScentsNote

final class MockHomeCoordinator: HomeCoordinator {
  
  var runOnboardingFlowCalledCount = 0
  var runPerfumeDetailFlowCalledCount = 0
  var runPerfumeNewFlowCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  var perfumeIdx = -1
  
  var runOnboardingFlow: (() -> Void)?
  
  init() {
    self.runOnboardingFlow = { [weak self] in
      self?.runOnboardingFlowCalledCount += 1
    }
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    self.runPerfumeDetailFlowCalledCount += 1
    self.perfumeIdx = perfumeIdx
  }
  
  func runPerfumeNewFlow() {
    self.runPerfumeNewFlowCalledCount += 1
  }
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
  
  
  
}
