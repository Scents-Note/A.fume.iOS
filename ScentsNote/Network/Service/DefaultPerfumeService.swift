//
//  DefaultPerfumeService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation
import RxSwift

final class DefaultPerfumeService: ScentsNoteService, PerfumeService {
  func fetchPerfumesInSurvey() -> Observable<ListInfo<Perfume>?> {
    requestObject(.fetchPerfumesInSurvey)
  }
  
  func fetchKeywords() -> Observable<ListInfo<SurveyKeyword>?> {
    requestObject(.fetchKeywords)
  }
  
  func fetchSeries() -> Observable<ListInfo<SurveySeries>?> {
    requestObject(.fetchSeries)
  }
  
  func fetchPerfumesRecommended() -> Observable<ListInfo<Perfume>?> {
    requestObject(.fetchPerfumesRecommended)
  }
  
  func fetchPerfumesPopular() -> Observable<ListInfo<Perfume>?> {
    requestObject(.fetchPerfumesPopular)
  }
  
  func fetchRecentPerfumes() -> Observable<ListInfo<Perfume>?> {
    requestObject(.fetchRecentPerfumes)
  }
  
  func fetchNewPerfumes() -> Observable<ListInfo<Perfume>?> {
    requestObject(.fetchNewPerfumes)
  }
  
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail?> {
    requestObject(.fetchPerfumeDetail(perfumeIdx: perfumeIdx))
  }
  
}
