//
//  SurveySeriesResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/14.
//

import Foundation

struct SurveySeriesResponseDTO: Decodable {
  let seriesIdx: Int
  let name: String
  let imageUrl: String
}

extension SurveySeriesResponseDTO {
  func toDomain() -> SurveySeries {
    SurveySeries(seriesIdx: self.seriesIdx,
                 name: self.name,
                 imageUrl: self.imageUrl)
  }
}
