//
//  PerfumeDetail.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//


struct PerfumeDetail: Hashable {
  let perfumeIdx: Int
  let name: String
  let brandName: String
  let story: String
  let abundanceRate: String
  let volumeAndPrice: [String]
  let imageUrls: [String]
  let score: Float
  let seasonal: [Seasonal]
  let sillage: [Sillage]
  let longevity: [Longevity]
  let gender: [Gender]
  let isLiked: Bool
  let Keywords: [String]
  let noteType: Int
  let ingredients: [Ingredient]
  let reviewIdx: Int
}
