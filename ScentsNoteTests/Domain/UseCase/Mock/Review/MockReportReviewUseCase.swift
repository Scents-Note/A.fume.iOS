//
//  MockReportReviewUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/31.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockReportReviewUseCase: ReportReviewUseCase {
  
  var reviewIdx = 0
  var reason = ""
  func execute(reviewIdx: Int, reason: String) -> Observable<String> {
    self.reviewIdx = reviewIdx
    self.reason = reason
    return Observable.just("")
  }
}
