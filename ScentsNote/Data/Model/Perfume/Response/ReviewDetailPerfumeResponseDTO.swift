//
//  PerfumeInReviewDetailResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

struct PerfumeInReviewDetailResponseDTO: Decodable {
  let perfumeIdx: Int
  let perfumeName: String
  let imageUrl: String
}

extension PerfumeInReviewDetailResponseDTO {
  func toDomain() -> PerfumeInReviewDetail {
    PerfumeInReviewDetail(idx: self.perfumeIdx, name: self.perfumeName, imageUrl: self.imageUrl)
  }
}
