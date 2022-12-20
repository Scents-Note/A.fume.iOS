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
  let perfume: PerfumeInReviewDetail?
  var keywords: [Keyword]
  let brand: BrandInReviewDetail?
  var access: Bool
  
  static let `default` = ReviewDetail(score: 0, content: "", perfume: nil, keywords: [], brand: nil, access: false)
}


extension ReviewDetail {
  func toEntity() -> ReviewDetailRequestDTO {
    ReviewDetailRequestDTO(score: self.score,
                            sillage: self.sillage,
                            longevity: self.longevity,
                            seasonal: self.seasonal,
                            gender: self.gender,
                            access: self.access,
                            content: self.content,
                            keywordsList: self.keywords.map{ $0.idx })
  }
}
