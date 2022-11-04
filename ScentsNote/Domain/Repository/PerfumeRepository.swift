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
  func fetchPerfumesInSurvey(completion: @escaping (Result<SurveyInfo<SurveyPerfume>?, NetworkError>) -> Void)
  func fetchKeywords(completion: @escaping (Result<SurveyInfo<SurveyKeyword>?, NetworkError>) -> Void)
  func fetchSeries(completion: @escaping (Result<SurveyInfo<SurveySeries>?, NetworkError>) -> Void)
}
