//
//  PerfumeService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import RxSwift

protocol PerfumeService {
  
  // Common
  func updatePerfumeLike(perfumeIdx: Int) -> Observable<Bool>
  
  // Survey
  func fetchPerfumesInSurvey() -> Observable<ListInfo<PerfumeResponseDTO>>
  func fetchSeries() -> Observable<ListInfo<SurveySeriesResponseDTO>>
  
  //Home
  func fetchPerfumesRecommended() -> Observable<ListInfo<PerfumeResponseDTO>>
  func fetchPerfumesPopular() -> Observable<ListInfo<PerfumeResponseDTO>>
  func fetchPerfumesRecent() -> Observable<ListInfo<PerfumeResponseDTO>>
  func fetchPerfumesNew(size: Int?) -> Observable<ListInfo<PerfumeResponseDTO>>
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetailResponseDTO>
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<ListInfo<PerfumeResponseDTO>>
  
  //Search
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearchRequestDTO) -> Observable<ListInfo<PerfumeResponseDTO>>
  
  //Review
  func fetchReviewsInPerfumeDetail(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetailResponseDTO]>
  func addReview(perfumeIdx: Int, perfumeReview: ReviewDetailRequestDTO) -> Observable<String>
}
