//
//  SurveyPerfume.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxDataSources

struct Perfume: Decodable, Hashable {
  
//  var identity: Int {
//    return Int.random(in: 0...1000)
//  }
  static func == (lhs: Perfume, rhs: Perfume) -> Bool {
    return lhs.perfumeIdx == rhs.perfumeIdx
  }
  
  let perfumeIdx: Int
  let brandName: String
  let name: String
  let imageUrl: String
  let keywordList: [String]?
  var isLiked: Bool
}
