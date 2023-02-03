//
//  MockPopUpCoordinator.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

@testable import ScentsNote

final class MockPopUpCoordinator: PopUpCoordinator {
  
  var showPopupCalledCount = 0
  var hidePopupCalledCount = 0
  
  func showPopup() {
    self.showPopupCalledCount += 1
  }
  
  func hidePopup() {
    self.hidePopupCalledCount += 1
  }
}
