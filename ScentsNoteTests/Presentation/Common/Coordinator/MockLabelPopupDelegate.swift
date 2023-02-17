//
//  MockLabelPopupDelegate.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

@testable import ScentsNote_Dev

final class MockLabelPopupDelegate: LabelPopupDelegate {
  
  var confirmCalledCount = 0
  
  func confirm() {
    self.confirmCalledCount += 1
  }
}
