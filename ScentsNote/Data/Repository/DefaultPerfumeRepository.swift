//
//  DefaultPerfumeRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation

final class DefaultPerfumeRepository: PerfumeRepository {
  
  private let perfumeService: PerfumeService
  
  init(perfumeService: PerfumeService){
    self.perfumeService = perfumeService
  }

  func fetchPerfumesInSurvey(completion: @escaping (Result<SurveyInfo<SurveyPerfume>?, NetworkError>) -> Void) {
    self.perfumeService.fetchPerfumesInSurvey(completion: completion)
  }
  
  func fetchKeywords(completion: @escaping (Result<SurveyInfo<SurveyKeyword>?, NetworkError>) -> Void) {
    self.perfumeService.fetchKeywords(completion: completion)
  }
}
