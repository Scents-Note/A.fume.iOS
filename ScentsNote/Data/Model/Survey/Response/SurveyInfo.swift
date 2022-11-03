//
//  SurveySeries.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation

struct SurveyInfo<T: Decodable>: Decodable {
  let count: Int
  let rows: [T]
}

struct SurveySeries: Decodable {
  let seriesIdx: Int
  let name: String
  let imageUrl: String
}

struct SurveyPerfume: Decodable {
  let perfumeIdx: Int
  let brandName: String
  let name: String
  let imageUrl: String
  var isLiked: Bool
}
