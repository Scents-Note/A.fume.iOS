//
//  DefaultPerfumeService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation
import RxSwift

final class DefaultPerfumeService: ScentsNoteService, PerfumeService {
  func fetchPerfumesInSurvey(completion: @escaping (Result<ListInfo<Perfume>?, NetworkError>) -> Void) {
    requestObject(.fetchPerfumesInSurvey, completion: completion)
  }
  
  func fetchKeywords(completion: @escaping (Result<ListInfo<SurveyKeyword>?, NetworkError>) -> Void) {
    requestObject(.fetchKeywords, completion: completion)
  }
  
  func fetchSeries(completion: @escaping (Result<ListInfo<SurveySeries>?, NetworkError>) -> Void) {
    requestObject(.fetchSeries, completion: completion)
  }
  
  func fetchPerfumesRecommended() -> Observable<ListInfo<Perfume>?> {
    requestObjectRx(.fetchPerfumesRecommended)
  }
  
  func fetchPerfumesPopular() -> Observable<ListInfo<Perfume>?> {
    requestObjectRx(.fetchPerfumesPopular)
  }
  
  func fetchRecentPerfumes() -> Observable<ListInfo<Perfume>?> {
    requestObjectRx(.fetchRecentPerfumes)
  }
  
  func fetchNewPerfumes() -> Observable<ListInfo<Perfume>?> {
    requestObjectRx(.fetchNewPerfumes)
  }
  
}
