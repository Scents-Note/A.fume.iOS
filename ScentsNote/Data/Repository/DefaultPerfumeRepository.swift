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
  
  func fetchPerfumesInSurvey() -> Observable<ListInfo<Perfume>?> {
    self.perfumeService.fetchPerfumesInSurvey()
  }
  
  func fetchKeywords() -> Observable<ListInfo<SurveyKeyword>?> {
    self.perfumeService.fetchKeywords()
  }
  
  func fetchSeries() -> Observable<ListInfo<SurveySeries>?> {
    self.perfumeService.fetchSeries()
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
