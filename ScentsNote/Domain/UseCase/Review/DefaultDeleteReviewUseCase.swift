//
//  DeleteReviewUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/03.
//

import RxSwift

protocol DeleteReviewUseCase {
  func execute(reviewIdx: Int) -> Observable<String>
}

final class DefaultDeleteReviewUseCase: DeleteReviewUseCase {
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(reviewIdx: Int) -> Observable<String> {
    return self.reviewRepository.deleteReview(reviewIdx: reviewIdx)
  }
}
