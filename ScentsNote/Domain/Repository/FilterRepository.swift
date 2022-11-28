//
//  FilterRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import RxSwift

protocol FilterRepository {
  
  func fetchSeriesForFilter() -> Observable<[FilterSeries]?>
  
}
