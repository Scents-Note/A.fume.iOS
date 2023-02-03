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
  
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  init() {
    self.runPerfumeDetailFlow = { [weak self] perfumeIdx in
      self?.perfumeIdx = perfumeIdx
    }
  }
  
  func runWebFlow(with url: String) {
    self.url = url
  }
  
  
}
