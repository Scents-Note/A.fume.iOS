//
//  ReviewInPerfumeDetailResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/29.
//

import Foundation

struct ReviewInPerfumeDetailResponseDTO: Decodable {
  let reviewIdx: Int
  let score: Double
  let access: Bool
  let content: String
  let likeCount: Int
  let isLiked: Bool
  let userGender: Int
  let age: String
  let nickname: String
  let createTime: String
  let isReported: Bool
}

extension ReviewInPerfumeDetailResponseDTO {
  func toDomain() -> ReviewInPerfumeDetail {
    ReviewInPerfumeDetail(idx: self.reviewIdx,
                          score: self.score,
                          access: self.access,
                          content: self.content,
                          likeCount: self.likeCount,
                          isLiked: self.isLiked,
                          gender: self.userGender,
                          age: self.age,
                          nickname: self.nickname,
                          isReported: self.isReported)
  }
}
