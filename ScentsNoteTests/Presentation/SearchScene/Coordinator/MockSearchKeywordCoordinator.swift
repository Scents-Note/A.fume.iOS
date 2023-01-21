//
//  MockSearchKeywordCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

@testable import ScentsNote

final class MockSearchKeywordCoordinator: SearchKeywordCoordinator {
  
  var finishFlowCalledCount = 0
  
  var finishFlow: ((PerfumeSearch) -> Void)?
  
  init() {
    let perfume = PerfumeSearch()
    self.finishFlow = { [weak self] perfume in
      self?.finishFlowCalledCount += 1
    }
  }
}
