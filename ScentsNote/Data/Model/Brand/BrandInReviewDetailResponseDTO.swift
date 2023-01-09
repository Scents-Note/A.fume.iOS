//
//  BrandInReviewDetailResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/09.
//

struct BrandInReviewDetailResponseDTO: Decodable {
  let brandIdx: Int
  let brandName: String
}

extension BrandInReviewDetailResponseDTO {
  func toDomain() -> BrandInReviewDetail {
    BrandInReviewDetail(idx: self.brandIdx, name: self.brandName)
  }
}
