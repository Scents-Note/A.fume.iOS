//
//  DefaultFilterRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import RxSwift

final class DefaultFilterRepository: FilterRepository {
  
  static let shared = DefaultFilterRepository(filterService: DefaultFilterService.shared)
  
  private let filterService: FilterService
  
  private init(filterService: FilterService){
    self.filterService = filterService
  }
  
  func fetchSeriesForFilter() -> Observable<[FilterSeries]> {
    self.filterService.fetchSeriesForFilter()
      .map { $0.rows.map { $0.toDomain()} }
  }
  
  func fetchBrandsForFilter() -> Observable<[FilterBrandInfo]> {
    self.filterService.fetchBrandsForFilter()
      .map { $0.map { $0.toDomain() }}
  }
}
