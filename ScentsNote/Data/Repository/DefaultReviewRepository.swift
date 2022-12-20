//
//  DefaultReviewRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

final class DefaultReviewRepository: ReviewRepository {
    
  private let reviewService: ReviewService
  
  init(reviewService: ReviewService) {
    self.reviewService = reviewService
  }
  
  func fetchReviewDetail(reviewIdx: Int) -> Observable<ReviewDetail> {
    self.reviewService.fetchReviewDetail(reviewIdx: reviewIdx)
      .map { $0.toDomain() }
  }
  
  func updateReview(reviewDetail: ReviewDetail) -> Observable<String> {
    self.reviewService.updateReview(reviewIdx: reviewDetail.reviewIdx!, reviewDetail: reviewDetail.toEntity())
  }
}
