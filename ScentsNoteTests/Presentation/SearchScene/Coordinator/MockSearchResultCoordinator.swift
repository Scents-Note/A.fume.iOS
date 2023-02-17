//
//  MockSearchResultCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

@testable import ScentsNote_Dev

final class MockSearchResultCoordinator: SearchResultCoordinator {
  
  var runOnboardingFlowCalledCount = 0
  var runSearchKeywordFlowCalledCount = 0
  var runSearchFilterFlowCalledCount = 0
  var finishFlowCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  var perfumeDetailIdx = -1
  var url = ""
  
  var runOnboardingFlow: (() -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  var runSearchKeywordFlow: (() -> Void)?
  var runSearchFilterFlow: (() -> Void)?
  var finishFlow: (() -> Void)?
  
  init() {
    self.runOnboardingFlow = { [weak self] in
      self?.runOnboardingFlowCalledCount += 1
    }
    self.runSearchKeywordFlow = { [weak self] in
      self?.runSearchKeywordFlowCalledCount += 1
    }
    self.runSearchFilterFlow = { [weak self] in
      self?.runSearchFilterFlowCalledCount += 1
    }
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
    
    self.runPerfumeDetailFlow = { [weak self] idx in
      self?.perfumeDetailIdx = idx
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
