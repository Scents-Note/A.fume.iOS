//
//  PerfumeKeyword.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import Foundation

struct PerfumeSearch {
  var searchWord: String? = ""
  var keywords: [Int] = []
  var ingredients: [Int] = []
  var brands: [Int] = []
}

extension PerfumeSearch {
  func toEntity() -> PerfumeSearchRequestDTO {
    PerfumeSearchRequestDTO(searchText: self.searchWord,
                            keywordList: self.keywords,
                            ingredientList: self.ingredients,
                            brandList: self.brands)
  }
}
