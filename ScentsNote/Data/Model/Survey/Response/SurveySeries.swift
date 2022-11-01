//
//  SurveySeries.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation

struct SurveySeriesInfo: Decodable {
  let count: Int
  let rows: [SurveySeries]
}

struct SurveySeries: Decodable {
  let seriesIdx: Int
  let name: String
  let imageUrl: String
}
