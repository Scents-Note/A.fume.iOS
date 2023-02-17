//
//  DefaultFetchPerfumesPopularUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol FetchPerfumesPopularUseCase {
  func execute() -> Observable<[Perfume]>
}

final class DefaultFetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute() -> Observable<[Perfume]> {
    perfumeRepository.fetchPerfumesPopular()
  }
}
