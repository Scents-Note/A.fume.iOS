//
//  PerfumeLikedResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

struct PerfumeInMyPageResponseDTO: Decodable {
  let perfumeIdx: Int
  let name: String
  let brandName: String
  let imageUrl: String
  let isLiked: Bool
  let reviewIdx: Int
  let priceComparisonUrl: String
}

extension PerfumeInMyPageResponseDTO {
  func toDomain() -> PerfumeInMyPage {
    PerfumeInMyPage(idx: self.perfumeIdx,
                 name: self.name,
                 brandName: self.brandName,
                 imageUrl: self.imageUrl,
                 reviewIdx: self.reviewIdx,
                 priceComparisonUrl: self.priceComparisonUrl)
  }
}
