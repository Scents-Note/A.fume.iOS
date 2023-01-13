//
//  DefaultReviewRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

final class DefaultReviewRepository: ReviewRepository {
  
  static let shared = DefaultReviewRepository(reviewService: DefaultReviewService.shared)

  private let reviewService: ReviewService
  
  private init(reviewService: ReviewService) {
    self.reviewService = reviewService
  }
  
  func fetchReviewDetail(reviewIdx: Int) -> Observable<ReviewDetail> {
    self.reviewService.fetchReviewDetail(reviewIdx: reviewIdx)
      .map { $0.toDomain() }
  }
  
  func updateReview(reviewDetail: ReviewDetail) -> Observable<String> {
    self.reviewService.updateReview(reviewIdx: reviewDetail.reviewIdx, reviewDetail: reviewDetail.toEntity())
  }
  
  func reportReview(reviewIdx: Int, reason: String) -> Observable<String> {
    let requestDTO = ReviewReportRequestDTO(reason: reason)
    return self.reviewService.reportReview(reviewIdx: reviewIdx, reason: requestDTO)
  }
  
  func updateReviewLike(reviewIdx: Int) -> Observable<Bool> {
    self.reviewService.updateReviewLike(reviewIdx: reviewIdx)
  }
  
  func deleteReview(reviewIdx: Int) -> Observable<String> {
    self.reviewService.deleteReview(reviewIdx: reviewIdx)
  }
}
