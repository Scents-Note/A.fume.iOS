//
//  IngredientResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

struct IngredientResponseDTO: Decodable, Hashable {
  let top: String
  let middle: String
  let base: String
  let single: String
}

extension IngredientResponseDTO {
  func toDomain() -> [Ingredient] {
    var list: [Ingredient] = []
    guard self.top.count != 0 || self.middle.count != 0 || self.base.count != 0 || self.single.count != 0 else {
      return [Ingredient(part: "empty", ingredient: "정보를 준비 중입니다.")]
    }
    if self.single.count == 0 {
      list.append(Ingredient(part: "Top", ingredient: self.top))
      list.append(Ingredient(part: "Middle", ingredient: self.middle))
      list.append(Ingredient(part: "Base", ingredient: self.base))
    } else {
      list.append(Ingredient(part: "Single", ingredient: self.single))
    }
    return list
  }
}
