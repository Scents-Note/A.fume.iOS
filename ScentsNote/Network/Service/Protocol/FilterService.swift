//
//  FilterService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import RxSwift

protocol FilterService {
  
  func fetchSeriesForFilter() -> Observable<ListInfo<FilterSeriesResponseDTO>>
  func fetchBrandsForFilter() -> Observable<[FilterBrandInfoResponseDTO]>
  
}
