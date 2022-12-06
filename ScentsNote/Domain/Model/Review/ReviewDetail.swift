//
//  PerfumeReview.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/03.
//

struct ReviewDetail {
  var score: Double
  var sillage: Int?
  var longevity: Int?
  var seasonal: [String]?
  var gender: Int?
  var content: String
  var reviewIdx: Int?
  let Perfume: PerfumeInReview?
  var keywords: [Keyword]
  let Brand: BrandInReview?
  let access: Bool
}

struct PerfumeInReview {
  let keywordIdx: Int
  let name: String
}

struct BrandInReview {
  let brandIdx: Int
  let brandName: String
}

extension ReviewDetail {
  func toEntity() -> ReviewDetailRequsetDTO {
    ReviewDetailRequsetDTO(score: self.score,
                            sillage: self.sillage,
                            longevity: self.longevity,
                            seasonal: self.seasonal,
                            gender: self.gender,
                            access: self.access,
                            content: self.content,
                            keywordsList: self.keywords.map{ $0.idx })
  }
}
