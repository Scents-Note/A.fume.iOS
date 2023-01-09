//
//  FilterBrandInfoResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import Foundation

struct FilterBrandInfoResponseDTO: Decodable {
  let firstInitial: String
  let brands: [FilterBrandResponseDTO]
}

extension FilterBrandInfoResponseDTO {
  func toDomain() -> FilterBrandInfo {
    FilterBrandInfo(initial: self.firstInitial, brands: self.brands.compactMap { $0.toDomain() })
  }
}
