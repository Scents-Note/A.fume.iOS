//
//  PerfumeReviewRequsetDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/03.
//

import Foundation

struct ReviewDetailRequsetDTO {
  let score: Double
  let sillage: Int?
  let longevity: Int?
  let seasonal: [String]?
  let gender: Int?
  let access: Bool
  let content: String
  let keywordsList: [Int]?
}
