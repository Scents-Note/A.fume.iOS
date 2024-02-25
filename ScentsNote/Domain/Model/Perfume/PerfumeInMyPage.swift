//
//  PerfumeLiked.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

struct PerfumeInMyPage: Equatable {
  let idx: Int
  let name: String
  let brandName: String
  let imageUrl: String
  let reviewIdx: Int
  let priceComparisonUrl: String
}

extension PerfumeInMyPage {
  // My Page에서
  func toPerfumeDetail() -> PerfumeDetail {
    PerfumeDetail(perfumeIdx: self.idx,
                  name: self.name,
                  brandName: self.brandName,
                  story: "",
                  abundanceRate: "",
                  volumeAndPrice: [],
                  imageUrls: [self.imageUrl],
                  score: 0, seasonal: [],
                  sillage: [],
                  longevity: [],
                  gender: [],
                  isLiked: false,
                  Keywords: [],
                  noteType: 0,
                  ingredients: [],
                  reviewIdx: 0,
                  priceComparisonUrl: self.priceComparisonUrl)
  }
}
