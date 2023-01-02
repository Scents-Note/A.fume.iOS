//
//  ReviewRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

import RxSwift

protocol ReviewRepository {
  func fetchReviewDetail(reviewIdx: Int) -> Observable<ReviewDetail>
  func updateReview(reviewDetail: ReviewDetail) -> Observable<String>
  func reportReview(reviewIdx: Int, reason: String) -> Observable<String>
  func updateReviewLike(reviewIdx: Int) -> Observable<Bool>
}
