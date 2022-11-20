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
  // MARK: - Survey
  func fetchPerfumesInSurvey() -> Observable<[Perfume]?>
  func fetchKeywords() -> Observable<ListInfo<SurveyKeyword>?>
  func fetchSeries() -> Observable<ListInfo<SurveySeries>?>
  
  // MARK: - Home
  func fetchPerfumesRecommended() -> Observable<[Perfume]?>
  func fetchPerfumesPopular() -> Observable<[Perfume]?>
  func fetchRecentPerfumes() -> Observable<[Perfume]?>
  func fetchNewPerfumes() -> Observable<[Perfume]?>
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail?>
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<[Perfume]?>
}
