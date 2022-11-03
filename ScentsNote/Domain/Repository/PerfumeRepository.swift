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
}
