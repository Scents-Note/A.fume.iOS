//
//  UpdateReviewLikeUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/02.
//

import RxSwift

final class UpdateReviewLikeUseCase {
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(reviewIdx: Int) -> Observable<Bool> {
    return self.reviewRepository.updateReviewLike(reviewIdx: reviewIdx)
  }
}
