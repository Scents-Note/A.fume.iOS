//
//  SurveySeries.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

struct SurveySeries: Decodable {
  let seriesIdx: Int
  let name: String
  let imageUrl: String
  var isLiked: Bool? = false
}
