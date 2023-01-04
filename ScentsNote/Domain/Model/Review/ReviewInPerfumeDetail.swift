//
//  PerfumeReviewInPerfumeDetail.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/29.
//

struct ReviewInPerfumeDetail: Equatable {
  let idx: Int
  let score: Double
  let access: Bool
  let content: String
  var likeCount: Int
  var isLiked: Bool
  let gender: Int
  let age: String
  let nickname: String
  let isReported: Bool
}
