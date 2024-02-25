//
//  PerfumeDetailResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import Foundation

struct PerfumeDetailResponseDTO: Decodable, Hashable {
  let perfumeIdx: Int
  let name: String
  let brandName: String
  let story: String
  let abundanceRate: String
  let volumeAndPrice: [String]
  let imageUrls: [String]
  let score: Double
  let seasonal: SeasonalResponseDTO
  let sillage: SillageResponseDTO
  let longevity: LongevityResponseDTO
  let gender: GenderResponseDTO
  let isLiked: Bool
  let Keywords: [String]
  let noteType: Int
  let ingredients: IngredientResponseDTO
  let reviewIdx: Int
  let priceComparisonUrl: String
}

extension PerfumeDetailResponseDTO {
  func toDomain() -> PerfumeDetail {
    PerfumeDetail(perfumeIdx: self.perfumeIdx,
                  name: self.name,
                  brandName: self.brandName,
                  story: self.story,
                  abundanceRate: self.abundanceRate,
                  volumeAndPrice: self.volumeAndPrice,
                  imageUrls: self.imageUrls,
                  score: self.score,
                  seasonal: self.seasonal.toDomain(),
                  sillage: self.sillage.toDomain(),
                  longevity: self.longevity.toDomain(),
                  gender: self.gender.toDomain(),
                  isLiked: self.isLiked,
                  Keywords: self.Keywords,
                  noteType: self.noteType,
                  ingredients: self.ingredients.toDomain(),
                  reviewIdx: self.reviewIdx,
                  priceComparisonUrl: self.priceComparisonUrl)
  }
}
