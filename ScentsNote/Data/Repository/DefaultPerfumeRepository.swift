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

  func fetchPerfumesInSurvey(completion: @escaping (Result<ListInfo<Perfume>?, NetworkError>) -> Void) {
    self.perfumeService.fetchPerfumesInSurvey(completion: completion)
  }
  
  func fetchKeywords(completion: @escaping (Result<ListInfo<SurveyKeyword>?, NetworkError>) -> Void) {
    self.perfumeService.fetchKeywords(completion: completion)
  }
  
  func fetchSeries(completion: @escaping (Result<ListInfo<SurveySeries>?, NetworkError>) -> Void) {
    self.perfumeService.fetchSeries(completion: completion)
  }
  
  func fetchPerfumesRecommended(completion: @escaping (Result<ListInfo<Perfume>?, NetworkError>) -> Void) {
    self.perfumeService.fetchPerfumesRecommended(completion: completion)
  }
  
  func fetchPerfumesPopular(completion: @escaping (Result<ListInfo<Perfume>?, NetworkError>) -> Void) {
    self.perfumeService.fetchPerfumesPopular(completion: completion)
  }
  
  func fetchRecentPerfumes(completion: @escaping (Result<ListInfo<Perfume>?, NetworkError>) -> Void) {
    self.perfumeService.fetchRecentPerfumes(completion: completion)
  }
  
  func fetchNewPerfumes(completion: @escaping (Result<ListInfo<Perfume>?, NetworkError>) -> Void) {
    self.perfumeService.fetchNewPerfumes(completion: completion)
  }
}
