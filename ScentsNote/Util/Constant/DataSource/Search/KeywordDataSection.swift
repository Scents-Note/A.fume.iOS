//
//  KeywordDataSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import RxDataSources

struct KeywordDataSection {
  typealias Model = AnimatableSectionModel<String, Item>
  
  struct Item: Hashable, IdentifiableType {
    var identity: Int {
      self.keyword.idx
    }
    var keyword: SearchKeyword
  }
}
