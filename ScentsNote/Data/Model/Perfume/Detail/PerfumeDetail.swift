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
  let seasonal: SeasonalResponseDTO
  let sillage: SillageResponseDTO
  let longevity: LongevityResponseDTO
  let gender: Gender
  let isLiked: Bool
  let Keywords: [String]
  let noteType: Int
  let ingredients: IngredientResponseDTO
  let reviewIdx: Int
}

struct Gender: Decodable, Hashable {
  let male: Int
  let neutral: Int
  let female: Int
}

