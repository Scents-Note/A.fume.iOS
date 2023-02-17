//
//  ReportReviewUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/23.
//

import RxSwift

protocol ReportReviewUseCase {
  func execute(reviewIdx: Int, reason: String) -> Observable<String>
}

final class DefaultReportReviewUseCase: ReportReviewUseCase {
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(reviewIdx: Int, reason: String) -> Observable<String> {
    return self.reviewRepository.reportReview(reviewIdx: reviewIdx, reason: reason)
  }
}
