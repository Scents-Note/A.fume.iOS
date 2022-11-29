//
//  KeywordResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import Foundation

struct KeywordResponseDTO: Decodable {
  let name: String
  let keywordIdx: Int
}

extension KeywordResponseDTO {
  func toDomain() -> Keyword {
    Keyword(idx: self.keywordIdx, name: self.name)
  }
}
