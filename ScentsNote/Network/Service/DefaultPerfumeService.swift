//
//  DefaultPerfumeService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation

final class DefaultPerfumeService: ScentsNoteService, PerfumeService {
  func fetchPerfumesInSurvey(completion: @escaping (Result<SurveyInfo<SurveyPerfume>?, NetworkError>) -> Void) {
    requestObject(.fetchPerfumesInSurvey, completion: completion)
  }
  
  func fetchKeywords(completion: @escaping (Result<SurveyInfo<SurveyKeyword>?, NetworkError>) -> Void) {
    requestObject(.fetchKeywords, completion: completion)
  }
  
  func fetchSeries(completion: @escaping (Result<SurveyInfo<SurveySeries>?, NetworkError>) -> Void) {
    requestObject(.fetchSeries, completion: completion)
  }
}
