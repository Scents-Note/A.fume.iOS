//
//  MockAddReviewUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/30.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockAddReviewUseCase: AddReviewUseCase {
  
  var excuteCallCount = 0
  func execute(perfumeIdx: Int, perfumeReview: ReviewDetail) -> Observable<String> {
    self.excuteCallCount += 1
    
    return Observable.create { observer in
      observer.onNext("추가 성공")
      return Disposables.create()
    }
  }
}
