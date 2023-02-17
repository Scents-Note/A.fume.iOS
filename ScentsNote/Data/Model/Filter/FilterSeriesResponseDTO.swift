//
//  FilterSeriesResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

struct FilterSeriesResponseDTO: Decodable {
  let seriesIdx: Int
  let name: String
  let ingredients: [FilterIngredientResponseDTO]
}

extension FilterSeriesResponseDTO {
  func toDomain() -> FilterSeries {
    FilterSeries(idx: self.seriesIdx, name: self.name, ingredients: self.ingredients.map { $0.toDomain(with: name) })
  }
}
