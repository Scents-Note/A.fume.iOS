//
//  MockPerfumeDetailCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/31.
//

@testable import ScentsNote

final class MockPerfumeDetailCoordinator: PerfumeDetailCoordinator {
  
  
  var finishFlowCalledCount = 0
  var runOnboardingFlowCalledCount = 0
  var runPerfumeReviewFlowCalledCount = 0
  var runPerfumeReviewFlowWithReviewIdxCalledCount = 0
  var runPerfumeDetailFlowCalledCount = 0
  var showPerfumeDetailViewControllerCalledCount = 0
  var runWebFlowCalledCount = 0
  var showReviewReportPopupViewControllerCalledCount = 0
  var hideReviewReportPopupViewControllerCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  var reviewIdx = 0
  var perfumeIdx = 0
  var perfumeDetail: PerfumeDetail?
  var url = ""
  var hasToast: Bool?
  
  var finishFlow: (() -> Void)?
  var runOnboardingFlow: (() -> Void)?
  var runPerfumeReviewFlow: ((PerfumeDetail) -> Void)?
  var runPerfumeReviewFlowWithReviewIdx: ((Int) -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  init() {
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
    
    self.runOnboardingFlow = { [weak self] in
      self?.runOnboardingFlowCalledCount += 1
    }
    
    self.runPerfumeReviewFlow = { [weak self] perfumeDetail in
      self?.perfumeDetail = perfumeDetail
      self?.runPerfumeReviewFlowCalledCount += 1
    }
    
    self.runPerfumeReviewFlowWithReviewIdx = { [weak self] reviewIdx in
      self?.reviewIdx = reviewIdx
      self?.runPerfumeReviewFlowWithReviewIdxCalledCount += 1
    }
  }
  
  func showPerfumeDetailViewController(perfumeIdx: Int) {
    self.perfumeIdx = perfumeIdx
    self.showPerfumeDetailViewControllerCalledCount += 1
  }
  
  func runWebFlow(with url: String) {
    self.url = url
    self.runWebFlowCalledCount += 1
  }
  
  func showReviewReportPopupViewController(reviewIdx: Int) {
    self.reviewIdx = reviewIdx
    self.showReviewReportPopupViewControllerCalledCount += 1
  }
  
  func hideReviewReportPopupViewController() {
    self.hideReviewReportPopupViewControllerCalledCount += 1
  }
  
  func hideReviewReportPopupViewController(hasToast: Bool) {
    self.hasToast = hasToast
    self.hideReviewReportPopupViewControllerCalledCount += 1
  }
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
}
