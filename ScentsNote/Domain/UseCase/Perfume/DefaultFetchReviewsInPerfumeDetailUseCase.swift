//
//  DefaultFetchReviewsInPerfumeDetailUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol FetchReviewsInPerfumeDetailUseCase {
  func execute(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]>
}

final class DefaultFetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase {
  private let perfumeRepository: PerfumeRepository
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]> {
    self.perfumeRepository.fetchReviewsInPerfumeDetail(perfumeIdx: perfumeIdx)
  }
}
