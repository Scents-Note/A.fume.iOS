//
//  SearchFilterSeriesViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import RxSwift
import RxCocoa

final class SearchFilterSeriesViewModel {
  
  let filterRepostiroy: FilterRepository
  let series = BehaviorRelay<[FilterSeries]>(value: [])

  init(filterRepository: FilterRepository) {
    self.filterRepostiroy = filterRepository
  }
  
  func updateSeries(series: [FilterSeries]) {
    self.series.accept(series)
  }
  
  private func fetchDatas(series: PublishRelay<[FilterSeries]>, disposeBag: DisposeBag) {
    self.filterRepostiroy.fetchSeriesForFilter()
      .subscribe { data in
        guard let data = data else { return }
        series.accept(data)
      }
      .disposed(by: disposeBag)
  }
}
