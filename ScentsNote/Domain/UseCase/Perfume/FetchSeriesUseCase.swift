//
//  FetchSeriesUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/20.
//

import RxSwift

final class FetchSeriesUseCase {
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute() -> Observable<ListInfo<SurveySeries>> {
    self.perfumeRepository.fetchSeries()
  }
}
