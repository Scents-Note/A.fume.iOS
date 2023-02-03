//
//  MockPerfumeNewCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/01.
//

@testable import ScentsNote

final class MockPerfumeNewCoordinator: PerfumeNewCoordinator {

  var url = ""
  var perfumeIdx = 0
  var runOnboardingFlowCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  var runOnboardingFlow: (() -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  init() {
    self.runOnboardingFlow = { [weak self] in
      self?.runOnboardingFlowCalledCount += 1
    }
    
    self.runPerfumeDetailFlow = { [weak self] perfumeIdx in
      self?.perfumeIdx = perfumeIdx
    }
  }
  
  func runWebFlow(with url: String) {
    self.url = url
  }
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
  
  
}
