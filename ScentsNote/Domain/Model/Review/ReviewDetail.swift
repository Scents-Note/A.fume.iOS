//
//  PerfumeReview.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/03.
//

struct ReviewDetail: Equatable {
  var score: Double
  var sillage: Int
  var longevity: Int
  var seasonal: [String]
  var gender: Int
  var content: String
  var reviewIdx: Int
  let perfume: PerfumeInReviewDetail?
  var keywords: [Keyword]
  let brand: BrandInReviewDetail?
  var isShared: Bool
  
  static let `default` = ReviewDetail(score: 0, sillage: -1, longevity: -1, seasonal: [], gender: -1, content: "", reviewIdx: 0, perfume: nil, keywords: [], brand: nil, isShared: false)
}


extension ReviewDetail {
  func toEntity() -> ReviewDetailRequestDTO {
    ReviewDetailRequestDTO(score: self.score,
                            sillage: self.sillage,
                            longevity: self.longevity,
                            seasonal: self.seasonal,
                            gender: self.gender,
                            access: self.isShared,
                            content: self.content,
                            keywordList: self.keywords.map{ $0.idx })
  }
  
  static func == (lhs: ReviewDetail, rhs: ReviewDetail) -> Bool {
    if lhs.isShared == rhs.isShared,
       lhs.score == rhs.score,
       lhs.sillage == rhs.sillage,
       lhs.longevity == rhs.longevity,
       lhs.seasonal == rhs.seasonal,
       lhs.gender == rhs.gender,
       lhs.content == rhs.content,
       lhs.keywords == rhs.keywords {
      return true
    }
    return false
  }
}
