//
//  DefaultFetchSeriesForFilterUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol FetchSeriesForFilterUseCase {
  func execute() -> Observable<[FilterSeries]>
}

final class DefaultFetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase {
  
  private let filterRepository: FilterRepository
  private let disposeBag = DisposeBag()
  
  init(filterRepository: FilterRepository) {
    self.filterRepository = filterRepository
  }
  
  func execute() -> Observable<[FilterSeries]> {
    self.filterRepository.fetchSeriesForFilter()
  }
}
