//
//  DefaultPerfumeRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import RxSwift

final class DefaultPerfumeRepository: PerfumeRepository {
  
  static let shared = DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)
  
  private let perfumeService: PerfumeService
  
  private init(perfumeService: PerfumeService){
    self.perfumeService = perfumeService
  }
  
  func fetchPerfumesInSurvey() -> Observable<[Perfume]> {
    self.perfumeService.fetchPerfumesInSurvey()
      .map { $0.rows.map { $0.toDomain()} }
  }
  
  func fetchSeries() -> Observable<[SurveySeries]> {
    self.perfumeService.fetchSeries()
      .map { $0.rows.map { $0.toDomain()}}
  }
  
  func fetchPerfumesRecommended() -> Observable<[Perfume]> {
    self.perfumeService.fetchPerfumesRecommended()
      .map { $0.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumesPopular() -> Observable<[Perfume]> {
    self.perfumeService.fetchPerfumesPopular()
      .map { $0.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumesRecent() -> Observable<[Perfume]> {
    self.perfumeService.fetchPerfumesRecent()
      .map { $0.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumesNew(size: Int?) -> Observable<[Perfume]> {
    self.perfumeService.fetchPerfumesNew(size: size)
      .map { $0.rows.map { $0.toDomain()} }
  }
  
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail> {
    self.perfumeService.fetchPerfumeDetail(perfumeIdx: perfumeIdx)
      .map { $0.toDomain() }
  }
  
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<[Perfume]> {
    self.perfumeService.fetchSimliarPerfumes(perfumeIdx: perfumeIdx)
      .map { $0.rows.map { $0.toDomain() } }
  }
  
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]> {
    let dto = perfumeSearch.toEntity()
    return self.perfumeService.fetchPerfumeSearched(perfumeSearch: dto)
      .map { $0.rows.map { $0.toDomain() } }
  }
  
  func fetchReviewsInPerfumeDetail(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]> {
    self.perfumeService.fetchReviewsInPerfumeDetail(perfumeIdx: perfumeIdx)
      .map { $0.map { $0.toDomain() } }
  }
  
  func updatePerfumeLike(perfumeIdx: Int) -> Observable<Bool> {
    self.perfumeService.updatePerfumeLike(perfumeIdx: perfumeIdx)
  }
  
  func addReview(perfumeIdx: Int, perfumeReview: ReviewDetail) -> Observable<String> {
    let requestDTO = perfumeReview.toEntity()
    return self.perfumeService.addReview(perfumeIdx: perfumeIdx, perfumeReview: requestDTO)
  }
}
