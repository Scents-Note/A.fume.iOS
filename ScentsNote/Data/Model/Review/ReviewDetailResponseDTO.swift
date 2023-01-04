//
//  ReviewDetailResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/06.
//

import Foundation

struct ReviewDetailResponseDTO: Decodable {
  let score: Double
  let sillage: Int
  let longevity: Int
  let seasonal: [String]
  let gender: Int
  let content: String
  let reviewIdx: Int
  let Perfume: PerfumeInReviewDetailResponseDTO
  let KeywordList: [KeywordResponseDTO]
  let Brand: BrandInReviewDetailResponseDTO
  let access: Bool
}

extension ReviewDetailResponseDTO {
  func toDomain() -> ReviewDetail {
    ReviewDetail(score: self.score,
                 sillage: self.sillage,
                 longevity: self.longevity,
                 seasonal: self.seasonal,
                 gender: self.gender,
                 content: self.content,
                 reviewIdx: self.reviewIdx,
                 perfume: self.Perfume.toDomain(),
                 keywords: self.KeywordList.map{ $0.toDomain() }.map { Keyword(idx: $0.idx, name: $0.name, isSelected: true) },
                 brand: self.Brand.toDomain(),
                 access: self.access)
  }
}
