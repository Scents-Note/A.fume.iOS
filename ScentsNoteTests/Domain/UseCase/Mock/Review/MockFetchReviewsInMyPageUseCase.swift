//
//  MockFetchReviewsInMyPageUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import RxSwift
@testable import ScentsNote

final class MockFetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase {
  
  var state: ResponseState = .success
  var error: Error = NetworkError.restError(statusCode: 403, description: "로그인이 안되어있습니다.")
  
  let reviews = [[ReviewInMyPage(reviewIdx: 0, score: 5.0, perfume: "가", imageUrl: "", brand: "ㄱ"),
                                ReviewInMyPage(reviewIdx: 1, score: 4.5, perfume: "나", imageUrl: "", brand: "ㄴ"),
                                ReviewInMyPage(reviewIdx: 2, score: 3.7, perfume: "다", imageUrl: "", brand: "ㄱ")],
                               [ReviewInMyPage(reviewIdx: 3, score: 5.0, perfume: "라", imageUrl: "", brand: "ㄱ"),
                                ReviewInMyPage(reviewIdx: 4, score: 4.5, perfume: "마", imageUrl: "", brand: "ㄴ"),
                                ReviewInMyPage(reviewIdx: 5, score: 3.7, perfume: "바", imageUrl: "", brand: "ㄱ")]]
  
  func execute() -> Observable<[[ReviewInMyPage]]> {
    Observable.create { [unowned self] observer in
      if state == .success {
        observer.onNext(self.reviews)
      } else {
        observer.onError(self.error)
      }
      return Disposables.create()
    }
  }
  
  func updateState(state: ResponseState) {
    self.state = state
  }
}
