//
//  ReviewService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/06.
//

import RxSwift

protocol ReviewService {
  func fetchReviewDetail(reviewIdx: Int) -> Observable<ReviewDetailResponseDTO>
  func updateReview(reviewIdx: Int, reviewDetail: ReviewDetailRequestDTO) -> Observable<String>
  func reportReview(reviewIdx: Int, reason: ReviewReportRequestDTO) -> Observable<String>
  func updateReviewLike(reviewIdx: Int) -> Observable<Bool>
}
