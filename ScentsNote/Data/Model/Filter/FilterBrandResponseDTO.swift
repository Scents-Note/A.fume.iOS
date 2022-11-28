//
//  FilterBrandResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import Foundation

struct FilterBrandResponseDTO: Decodable {
  let brandIdx: Int
  let name: String
}

extension FilterBrandResponseDTO {
  func toDomain() -> FilterBrand {
    FilterBrand(idx: self.brandIdx, name: self.name, isSelected: false)
  }
}
