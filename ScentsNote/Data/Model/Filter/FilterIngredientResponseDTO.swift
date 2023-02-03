//
//  FilterIngredientResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

struct FilterIngredientResponseDTO: Decodable {
  let ingredientIdx: Int
  let name: String
}

extension FilterIngredientResponseDTO {
  func toDomain(with series :String) -> FilterIngredient {
    FilterIngredient(id: "\(series)\(self.ingredientIdx)",idx: self.ingredientIdx, name: self.name, isSelected: false)
  }
}
