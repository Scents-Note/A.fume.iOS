//
//  FetchReviewDetailUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

final class FetchReviewDetailUseCase {
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(reviewIdx: Int) -> Observable<ReviewDetail> {
    Log(reviewIdx)
    return self.reviewRepository.fetchReviewDetail(reviewIdx: reviewIdx)
  }
}
