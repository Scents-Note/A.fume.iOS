//
//  AddReviewUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import RxSwift

final class AddReviewUseCase {
  private let repository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(repository: PerfumeRepository) {
    self.repository = repository
  }
  
  func execute(perfumeIdx: Int, perfumeReview: PerfumeReview) -> Observable<String> {
    return self.repository.addReview(perfumeIdx: perfumeIdx, perfumeReview: perfumeReview)
  }
}
