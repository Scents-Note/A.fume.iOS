//
//  PerfumeLikedResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

struct PerfumeLikedResponseDTO: Decodable {
  let perfumeIdx: Int
  let name: String
  let brandName: String
  let imageUrl: String
  let isLiked: Bool
  let reviewIdx: Int
}

extension PerfumeLikedResponseDTO {
  func toDomain() -> PerfumeLiked {
    PerfumeLiked(idx: self.perfumeIdx,
                 name: self.name,
                 brandName: self.brandName,
                 imageUrl: self.imageUrl,
                 reviewIdx: self.reviewIdx)
  }
}
