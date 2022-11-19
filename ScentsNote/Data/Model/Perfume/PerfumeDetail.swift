//
//  PerfumeDetail.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import Foundation

struct PerfumeDetail: Decodable, Hashable {
  let perfumeIdx: Int
  let name: String
  let brandName: String
  let story: String
  let abundanceRate: String
  let volumeAndPrice: [String]
  let imageUrls: [String]
  let score: Float
  let seasonal: Seasonal
  let sillage: Sillage
  let longevity: Longevity
  let gender: Gender
  let isLiked: Bool
  let Keywords: [String]
  let noteType: Int
  let ingredients: Ingredient
  let reviewIdx: Int
}

struct Seasonal: Decodable, Hashable {
  let spring: Int
  let summer: Int
  let fall: Int
  let winter: Int
}

struct Sillage: Decodable, Hashable {
  let light: Int
  let medium: Int
  let heavy: Int
}

struct Longevity: Decodable, Hashable {
  let veryWeak: Int
  let weak: Int
  let normal: Int
  let strong: Int
  let veryStrong: Int
}

struct Gender: Decodable, Hashable {
  let male: Int
  let neutral: Int
  let female: Int
}

struct Ingredient: Decodable, Hashable {
  let top: String
  let middle: String
  let base: String
  let single: String
}

extension Ingredient {
  func toList() -> [(String, String)] {
    if self.single.count == 0 {
      var list: [(String, String)] = []
      list.append(("Top", self.top))
      list.append(("Middle", self.middle))
      list.append(("Base", self.base))
      return list
    } else {
      return [("Single", self.single)]
    }
  }
}

extension Seasonal {
  func toList() -> [SeasonalInfo] {
    var list: [SeasonalInfo] = []
    list.append(SeasonalInfo(season: "봄", percent: CGFloat(self.spring)))
    list.append(SeasonalInfo(season: "여름", percent: CGFloat(self.summer)))
    list.append(SeasonalInfo(season: "가을", percent: CGFloat(self.fall)))
    list.append(SeasonalInfo(season: "겨울", percent: CGFloat(self.winter)))
    return list
  }
}
