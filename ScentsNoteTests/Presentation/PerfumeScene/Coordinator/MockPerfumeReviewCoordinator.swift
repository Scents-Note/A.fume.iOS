//
//  MockPerfumeReviewCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/30.
//

@testable import ScentsNote

final class MockPerfumeReviewCoordinator: PerfumeReviewCoordinator {
  
  var finishFlowCalledCount = 0
  var runPerfumeDetailFlowCalledCount = 0
  var showKeywordBottomSheetViewControllerCalledCount = 0
  var hideKeywordBottomSheetViewControllerCalledCount = 0
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  var keywords: [Keyword] = []
  var reviewIdx = 0
  
  var finishFlow: (() -> Void)?
  
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  init() {
    self.finishFlow = { [weak self] in
      self?.finishFlowCalledCount += 1
    }
    
    self.runPerfumeDetailFlow = { [weak self] idx in
      self?.runPerfumeDetailFlowCalledCount += 1
      self?.reviewIdx = idx
    }
  }
  
  func showKeywordBottomSheetViewController(keywords: [Keyword]) {
    self.showKeywordBottomSheetViewControllerCalledCount += 1
    self.keywords = keywords
  }
  
  func hideKeywordBottomSheetViewController(keywords: [Keyword]) {
    self.hideKeywordBottomSheetViewControllerCalledCount += 1
    self.keywords = keywords
  }
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
  
  
}
