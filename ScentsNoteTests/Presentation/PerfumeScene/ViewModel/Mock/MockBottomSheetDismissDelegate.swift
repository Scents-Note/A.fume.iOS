//
//  MockBottomSheetDismissDelegate.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/31.
//

@testable import ScentsNote

final class MockBottomSheetDismissDelegate: BottomSheetDismissDelegate {
  
  var keywords: [Keyword] = []
  
  func setKeywordsFromBottomSheet(keywords: [Keyword]) {
    self.keywords = keywords
  }
}
