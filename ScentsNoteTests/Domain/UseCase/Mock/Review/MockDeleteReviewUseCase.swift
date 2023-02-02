//
//  MockDeleteReviewUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/30.
//

import RxSwift
@testable import ScentsNote

final class MockDeleteReviewUseCase: DeleteReviewUseCase {
  
  var reviewIdx = 0
  
  func execute(reviewIdx: Int) -> Observable<String> {
    self.reviewIdx = reviewIdx
    return Observable.create { observer in
      observer.onNext("추가 성공")
      return Disposables.create()
    }
  }
}

