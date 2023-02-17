//
//  MockSearchCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

@testable import ScentsNote_Dev

final class MockSearchCoordinator: SearchCoordinator {
  
  var runOnboardingFlowCalledCount = 0
  var runPerfumeDetailFlowCalledCount = 0
  var runPerfumeReviewFlowCalledCount = 0
  var runPerfumeReviewFlowWithIdxCalledCount = 0
  var runSearchKeywordFlowCalledCount = 0
  var runSearchResultFlowCalledCount = 0
  var runSearchFilterFlowCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  var runOnboardingFlow: (() -> Void)?
  
  init() {
    self.runOnboardingFlow = { [weak self] in
      self?.runOnboardingFlowCalledCount += 1
    }
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    self.runPerfumeDetailFlowCalledCount += 1
  }
  
  func runPerfumeReviewFlow(perfumeDetail: PerfumeDetail) {
    self.runPerfumeReviewFlowCalledCount += 1
  }
  
  func runPerfumeReviewFlow(reviewIdx: Int) {
    self.runPerfumeReviewFlowWithIdxCalledCount += 1
  }
  
  func runSearchKeywordFlow(from: CoordinatorType) {
    self.runSearchKeywordFlowCalledCount += 1
  }
  
  func runSearchResultFlow(perfumeSearch: PerfumeSearch) {
    self.runSearchResultFlowCalledCount += 1
  }
  
  func runSearchFilterFlow(from: CoordinatorType) {
    self.runSearchFilterFlowCalledCount += 1
  }
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
  
  
}
