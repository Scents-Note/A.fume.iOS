//
//  MockMyPageCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

@testable import ScentsNote

final class MockMyPageCoordinator: MyPageCoordinator {
  
  var runOnboardingFlowCalledCount = 0
  var runPerfumeReviewFlowWithReviewIdxCalledCount = 0
  var runPerfumeReviewFlowCalledCount = 0
  var runPerfumeDetailFlowCalledCount = 0
  var runEditInfoFlowCalledCount = 0
  var runChangePasswordFlowCalledCount = 0
  var runWebFlowCalledCount = 0
  var showMyPageMenuViewControllerCalledCount = 0
  var hideMyPageMenuViewControllerCalledCount = 0
  
  var runOnboardingFlow: (() -> Void)?
  
  init() {
    self.runOnboardingFlow = { [weak self] in
      self?.runOnboardingFlowCalledCount += 1
    }
  }
  
  func runPerfumeReviewFlow(reviewIdx: Int) {
    self.runPerfumeReviewFlowWithReviewIdxCalledCount += 1
  }
  
  func runPerfumeReviewFlow(perfumeDetail: PerfumeDetail) {
    self.runPerfumeReviewFlowCalledCount += 1
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    self.runPerfumeDetailFlowCalledCount += 1
  }
  
  func runEditInfoFlow() {
    self.runEditInfoFlowCalledCount += 1
  }
  
  func runChangePasswordFlow() {
    self.runChangePasswordFlowCalledCount += 1
  }
  
  func runWebFlow(with url: String) {
    self.runWebFlowCalledCount += 1
  }
  
  func showMyPageMenuViewController() {
    self.showMyPageMenuViewControllerCalledCount += 1
  }
  
  func hideMyPageMenuViewController() {
    self.hideMyPageMenuViewControllerCalledCount += 1
  }
  
  
}
