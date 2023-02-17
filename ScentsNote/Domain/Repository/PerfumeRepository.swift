//
//  PerfumeRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation
import RxSwift
import Moya

protocol PerfumeRepository {
  
  // MARK: - Common
  func updatePerfumeLike(perfumeIdx: Int) -> Observable<Bool>
  
  // MARK: - Survey
  func fetchPerfumesInSurvey() -> Observable<[Perfume]>
  func fetchSeries() -> Observable<[SurveySeries]>
  
  // MARK: - Home
  func fetchPerfumesRecommended() -> Observable<[Perfume]>
  func fetchPerfumesPopular() -> Observable<[Perfume]>
  func fetchPerfumesRecent() -> Observable<[Perfume]>
  func fetchPerfumesNew(size: Int?) -> Observable<[Perfume]>
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail>
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<[Perfume]>
  
  // MARK: - Search
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]>
  
  // MARK: - Review
  func fetchReviewsInPerfumeDetail(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]>
  func addReview(perfumeIdx: Int, perfumeReview: ReviewDetail) -> Observable<String>
}
