//
//  DefaultFilterService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import Foundation
import RxSwift

final class DefaultFilterService: ScentsNoteService, FilterService {
  
  static let shared: DefaultFilterService = DefaultFilterService()

  func fetchSeriesForFilter() -> Observable<ListInfo<FilterSeriesResponseDTO>?> {
    requestObject(.fetchSeriesForFilter)
  }
  
  
}
