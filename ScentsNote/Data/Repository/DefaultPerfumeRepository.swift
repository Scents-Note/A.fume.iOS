//
//  DefaultPerfumeRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation
import RxSwift

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
  
  func fetchPerfumesRecommended() -> Observable<ListInfo<Perfume>?> {
    self.perfumeService.fetchPerfumesRecommended()
  }
  
  func fetchPerfumesPopular() -> Observable<ListInfo<Perfume>?> {
    self.perfumeService.fetchPerfumesPopular()
  }
  
  func fetchRecentPerfumes() -> Observable<ListInfo<Perfume>?> {
    self.perfumeService.fetchRecentPerfumes()
  }
  
  func fetchNewPerfumes() -> Observable<ListInfo<Perfume>?> {
    self.perfumeService.fetchNewPerfumes()
  }
  
}
