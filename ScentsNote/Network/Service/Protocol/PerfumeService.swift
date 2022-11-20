//
//  PerfumeService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation
import RxSwift

protocol PerfumeService {
  
  // Survey
  func fetchPerfumesInSurvey() -> Observable<ListInfo<PerfumeResponseDTO>?>
  func fetchKeywords() -> Observable<ListInfo<SurveyKeyword>?>
  func fetchSeries() -> Observable<ListInfo<SurveySeries>?>
  
  //Home
  func fetchPerfumesRecommended() -> Observable<ListInfo<PerfumeResponseDTO>?>
  func fetchPerfumesPopular() -> Observable<ListInfo<PerfumeResponseDTO>?>
  func fetchRecentPerfumes() -> Observable<ListInfo<PerfumeResponseDTO>?>
  func fetchNewPerfumes() -> Observable<ListInfo<PerfumeResponseDTO>?>
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetailResponseDTO?>
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<ListInfo<PerfumeResponseDTO>?>
}
