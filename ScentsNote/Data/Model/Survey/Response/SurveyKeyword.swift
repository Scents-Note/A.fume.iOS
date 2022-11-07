//
//  SurveySeries.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

struct SurveyKeyword: Decodable {
  let keywordIdx: Int
  let name: String
  var isLiked: Bool? = false
}
