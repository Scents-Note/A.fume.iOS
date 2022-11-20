//
//  Perfume.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

struct Perfume: Hashable {
  let perfumeIdx: Int
  let brandName: String
  let name: String
  let imageUrl: String
  let keywordList: [String]?
  var isLiked: Bool
}
