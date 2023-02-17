//
//  MockFetchReviewDetailUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/30.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchReviewDetailUseCase: FetchReviewDetailUseCase {
  
  func execute(reviewIdx: Int) -> Observable<ReviewDetail> {
    let reviewDetail = ReviewDetail(score: 4.5,
                                    sillage: 2,
                                    longevity: 0,
                                    seasonal: ["여름", "겨울"],
                                    gender: 2,
                                    content: "향수가 좋아요",
                                    reviewIdx: 10,
                                    perfume: PerfumeInReviewDetail(idx: 5, name: "향수", imageUrl: ""),
                                    keywords: [Keyword(idx: 0, name: "키워드0"), Keyword(idx: 1, name: "키워드1")],
                                    brand: BrandInReviewDetail(idx: 24, name: "조 말론"),
                                    isShared: true)
    
    
    return Observable.create { observer in
      observer.onNext(reviewDetail)
      return Disposables.create()
    }
  }
}
