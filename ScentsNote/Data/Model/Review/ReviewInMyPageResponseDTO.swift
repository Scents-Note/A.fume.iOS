//
//  ReviewInMyPageResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/06.
//

struct ReviewInMyPageResponseDTO: Decodable {
  let reviewIdx: Int
  let score: Double
  let perfumeIdx: Int
  let perfumeName: String
  let imageUrl: String
  let brandIdx: Int
  let brandName: String
}

extension ReviewInMyPageResponseDTO {
  func toDomain() -> ReviewInMyPage {
    ReviewInMyPage(reviewIdx: self.reviewIdx,
                   score: self.score,
                   perfume: self.perfumeName,
                   imageUrl: self.imageUrl,
                   brand: self.brandName)
  }
}
