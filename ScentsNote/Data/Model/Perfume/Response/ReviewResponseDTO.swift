//
//  ReviewResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/29.
//

import Foundation

struct ReviewResponseDTO: Decodable {
  let reviewIdx: Int
  let score: Float
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

extension ReviewResponseDTO {
  func toDomain() -> Review {
    Review(score: self.score,
           access: self.access,
           content: self.content,
           likeCount: self.likeCount,
           isLiked: self.isLiked,
           gender: self.userGender,
           age: self.age,
           nickname: self.nickname)
  }
}
