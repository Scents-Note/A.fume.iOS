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
  func fetchPerfumesInSurvey() -> Observable<ListInfo<Perfume>?>
  func fetchKeywords() -> Observable<ListInfo<SurveyKeyword>?>
  func fetchSeries() -> Observable<ListInfo<SurveySeries>?>
  
  // MARK: - Home
  func fetchPerfumesRecommended() -> Observable<ListInfo<Perfume>?>
  func fetchPerfumesPopular() -> Observable<ListInfo<Perfume>?>
  func fetchRecentPerfumes() -> Observable<ListInfo<Perfume>?>
  func fetchNewPerfumes() -> Observable<ListInfo<Perfume>?>
  
}
