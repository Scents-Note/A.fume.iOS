//
//  PerfumeKeyword.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import Foundation

struct PerfumeSearch {
  var searchWord: String? = nil
  var keywords: [SearchKeyword] = []
  var ingredients: [SearchKeyword] = []
  var brands: [SearchKeyword] = []
  
  static let `default` = PerfumeSearch()
}

struct SearchKeyword: Hashable {
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
  
  func toKeywordList() -> [SearchKeyword] {
    var list: [SearchKeyword] = []
    if searchWord != nil {
      list += [SearchKeyword(idx: -1, name: self.searchWord!, category: .searchWord)]
    } else {
      list += keywords
      list += ingredients
      list += brands
    }
    return list
  }
}
