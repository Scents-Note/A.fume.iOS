//
//  DefaultReviewService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

final class DefaultReviewService: ScentsNoteService, ReviewService {
  
  static let shared: DefaultReviewService = DefaultReviewService()
  private override init() {}

  func fetchReviewDetail(reviewIdx: Int) -> Observable<ReviewDetailResponseDTO> {
    requestObject(.fetchReviewDetail(reviewIdx: reviewIdx))
  }
  
  func updateReview(reviewIdx: Int, reviewDetail: ReviewDetailRequestDTO) -> Observable<String> {
    requestPlainObject(.updateReview(reviewIdx: reviewIdx, reviewDetail: reviewDetail))
  }
  
  func reportReview(reviewIdx: Int, reason: ReviewReportRequestDTO) -> Observable<String> {
    requestPlainObject(.reportReview(reviewIdx: reviewIdx, reason: reason))
  }
  
  func updateReviewLike(reviewIdx: Int) -> Observable<Bool> {
    requestObject(.updateReviewLike(reviewIdx: reviewIdx))
  }
  
  func deleteReview(reviewIdx: Int) -> Observable<String> {
    requestPlainObject(.deleteReview(reviewIdx: reviewIdx))
  }
  
}
