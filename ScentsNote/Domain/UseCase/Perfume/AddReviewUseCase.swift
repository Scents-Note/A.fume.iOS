//
//  AddReviewUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import RxSwift

final class AddReviewUseCase {
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(perfumeIdx: Int, perfumeReview: ReviewDetail) -> Observable<String> {
    return self.perfumeRepository.addReview(perfumeIdx: perfumeIdx, perfumeReview: perfumeReview)
  }
}
