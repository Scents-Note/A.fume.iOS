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
  
  func fetchPerfumesInSurvey() -> Observable<[Perfume]?> {
    self.perfumeService.fetchPerfumesInSurvey()
      .map { $0?.rows.map { $0.toDomain()} }
  }
  
  func fetchKeywords() -> Observable<ListInfo<SurveyKeyword>?> {
    self.perfumeService.fetchKeywords()
  }
  
  func fetchSeries() -> Observable<ListInfo<SurveySeries>?> {
    self.perfumeService.fetchSeries()
  }
  
  func fetchPerfumesRecommended() -> Observable<[Perfume]?> {
    self.perfumeService.fetchPerfumesRecommended()
      .map { $0?.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumesPopular() -> Observable<[Perfume]?> {
    self.perfumeService.fetchPerfumesPopular()
      .map { $0?.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumesRecent() -> Observable<[Perfume]?> {
    self.perfumeService.fetchPerfumesRecent()
      .map { $0?.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumesNew(size: Int?) -> Observable<[Perfume]?> {
    self.perfumeService.fetchPerfumesNew(size: size)
      .map { $0?.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail?> {
    self.perfumeService.fetchPerfumeDetail(perfumeIdx: perfumeIdx)
      .map { $0?.toDomain() }
  }
  
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<[Perfume]?> {
    self.perfumeService.fetchSimliarPerfumes(perfumeIdx: perfumeIdx)
      .map { $0?.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearch) -> Observable<ListInfo<PerfumeResponseDTO>?> {
    let dto = perfumeSearch.toEntity()
    return self.perfumeService.fetchPerfumeSearched(perfumeSearch: dto)
  }
  
}
