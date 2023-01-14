//
//  FetchSeriesUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/20.
//

import RxSwift

protocol FetchSeriesUseCase {
  func execute() -> Observable<[SurveySeries]>
}

final class DefaultFetchSeriesUseCase: FetchSeriesUseCase {
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute() -> Observable<[SurveySeries]> {
    self.perfumeRepository.fetchSeries()
  }
}
