//
//  SurveySeries.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import Foundation

import RxDataSources

struct SurveyInfo<T: Decodable>: Decodable {
  let count: Int
  let rows: [T]
}

struct SurveySeries: Decodable {
  let seriesIdx: Int
  let name: String
  let imageUrl: String
  var isLiked: Bool? = false
}

struct SurveyPerfume: IdentifiableType, Decodable, Equatable {
  var identity: Int {
          return perfumeIdx
      }
  let perfumeIdx: Int
  let brandName: String
  let name: String
  let imageUrl: String
  var isLiked: Bool
}

struct SurveyKeyword: Decodable {
  let keywordIdx: Int
  let name: String
  var isLiked: Bool? = false
}
