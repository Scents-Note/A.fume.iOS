//
//  MockUpdateReviewUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/30.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockUpdateReviewUseCase: UpdateReviewUseCase {
  
  var reviewDetail: ReviewDetail?
  
  func execute(reviewDetail: ReviewDetail) -> Observable<String> {
    self.reviewDetail = reviewDetail
    return Observable.create { observer in
      observer.onNext("추가 성공")
      return Disposables.create()
    }
  }
}
