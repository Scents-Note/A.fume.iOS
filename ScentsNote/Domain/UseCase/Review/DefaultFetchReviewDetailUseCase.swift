//
//  DefaultFetchReviewDetailUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

protocol FetchReviewDetailUseCase {
  func execute(reviewIdx: Int) -> Observable<ReviewDetail>
}

final class DefaultFetchReviewDetailUseCase: FetchReviewDetailUseCase {
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(reviewIdx: Int) -> Observable<ReviewDetail> {
    Log(reviewIdx)
    return self.reviewRepository.fetchReviewDetail(reviewIdx: reviewIdx)
  }
}
