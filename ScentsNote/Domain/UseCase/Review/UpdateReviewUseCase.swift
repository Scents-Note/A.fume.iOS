//
//  UpdateReviewUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

final class UpdateReviewUseCase {
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(reviewDetail: ReviewDetail) -> Observable<String> {
    return self.reviewRepository.updateReview(reviewDetail: reviewDetail)
  }
}
