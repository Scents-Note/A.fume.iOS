//
//  PerfumeKeyword.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import Foundation

struct PerfumeSearch {
  var searchWord: String? = nil
  var keywords: [Keyword] = []
  var ingredients: [Keyword] = []
  var brands: [Keyword] = []
  
  static let `default` = PerfumeSearch()
}

struct Keyword: Hashable {
  let idx: Int
  let name: String
  let category: SearchCategory
}

enum SearchCategory: Equatable {
  case searchWord
  case keyword
  case ingredient
  case brand
}

extension PerfumeSearch {
  func toEntity() -> PerfumeSearchRequestDTO {
    PerfumeSearchRequestDTO(searchText: self.searchWord,
                            keywordList: self.keywords.map { $0.idx },
                            ingredientList: self.ingredients.map { $0.idx },
                            brandList: self.brands.map { $0.idx })
  }
  
  func toKeywordList() -> [Keyword] {
    var list: [Keyword] = []
    if searchWord != nil {
      list += [Keyword(idx: -1, name: self.searchWord!, category: .searchWord)]
    } else {
      list += keywords
      list += ingredients
      list += brands
    }
    return list
  }
}
