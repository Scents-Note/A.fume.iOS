//
//  MockSearchFilterCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/25.
//

@testable import ScentsNote_Dev

final class MockSearchFilterCoordinator: SearchFilterCoordinator {
  
  var finishFlowCalledCount = 0
  
  var finishFlow: ((PerfumeSearch?) -> Void)?
  
  init() {
    self.finishFlow = { [weak self] _ in
      self?.finishFlowCalledCount += 1
    }
  }
}
