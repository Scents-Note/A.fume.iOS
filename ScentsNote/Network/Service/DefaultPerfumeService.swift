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
}
