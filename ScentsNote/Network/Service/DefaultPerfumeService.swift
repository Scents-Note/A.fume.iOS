//
//  DefaultPerfumeService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation
import RxSwift

final class DefaultPerfumeService: ScentsNoteService, PerfumeService {

  static let shared: DefaultPerfumeService = DefaultPerfumeService()

  func fetchPerfumesInSurvey() -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchPerfumesInSurvey)
  }
  
  func fetchSeries() -> Observable<ListInfo<SurveySeries>> {
    requestObject(.fetchSeries)
  }
  
  func fetchPerfumesRecommended() -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchPerfumesRecommended)
  }
  
  func fetchPerfumesPopular() -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchPerfumesPopular)
  }
  
  func fetchPerfumesRecent() -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchPerfumesRecent)
  }
  
  func fetchPerfumesNew(size: Int?) -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchPerfumesNew(size: size))
  }
  
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetailResponseDTO> {
    requestObject(.fetchPerfumeDetail(perfumeIdx: perfumeIdx))
  }
  
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchSimilarPerfumes(perfumeIdx: perfumeIdx))
  }
  
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearchRequestDTO) -> Observable<ListInfo<PerfumeResponseDTO>> {
    requestObject(.fetchPerfumesSearched(perfumeSearch: perfumeSearch))
  }
  
  func fetchReviewsInPerfumeDetail(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetailResponseDTO]> {
    requestObject(.fetchReviewsInPerfumeDetail(perfumeIdx: perfumeIdx))
  }
  
  func updatePerfumeLike(perfumeIdx: Int) -> Observable<Bool> {
    requestObject(.updatePerfumeLike(perfumeIdx: perfumeIdx))
  }
  
  func addReview(perfumeIdx: Int, perfumeReview: ReviewDetailRequestDTO) -> Observable<String> {
    requestPlainObject(.addReview(perfumeIdx: perfumeIdx, perfumeReview: perfumeReview))
  }
  
  
}
