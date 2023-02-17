//
//  MockReviewRepository.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockReviewRepository: ReviewRepository {
  func fetchReviewDetail(reviewIdx: Int) -> Observable<ReviewDetail> {
    let reviewDetail = ReviewDetail(score: 5.0,
                                    sillage: 1,
                                    longevity: 1,
                                    seasonal: ["여름"],
                                    gender: 1,
                                    content: "향이 좋네여",
                                    reviewIdx: 0,
                                    perfume: PerfumeInReviewDetail(idx: 0, name: "가", imageUrl: ""),
                                    keywords: [Keyword(idx: 0, name: "고",isSelected: false)],
                                    brand: BrandInReviewDetail(idx: 0, name: "ㄱ"),
                                    isShared: true)
    
    return Observable.create { observer in
      observer.onNext(reviewDetail)
      return Disposables.create()
    }
  }
  
  func updateReview(reviewDetail: ReviewDetail) -> Observable<String> {
    let description = "업데이트 되었습니다."
    return Observable.create { observer in
      observer.onNext(description)
      return Disposables.create()
    }
  }
  
  func reportReview(reviewIdx: Int, reason: String) -> Observable<String> {
    let description = "신고 되었습니다."
    return Observable.create { observer in
      observer.onNext(description)
      return Disposables.create()
    }
  }
  
  func updateReviewLike(reviewIdx: Int) -> Observable<Bool> {
    let isSuccess = true
    return Observable.create { observer in
      observer.onNext(isSuccess)
      return Disposables.create()
    }
  }
  
  func deleteReview(reviewIdx: Int) -> Observable<String> {
    let description = "삭제 되었습니다."
    return Observable.create { observer in
      observer.onNext(description)
      return Disposables.create()
    }
  }
  
  
}
