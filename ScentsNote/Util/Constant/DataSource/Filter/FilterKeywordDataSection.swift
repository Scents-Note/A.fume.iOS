//
//  FilterKeywordDataSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxDataSources

struct FilterKeywordDataSection {
  typealias Model = AnimatableSectionModel<String, Item>
  
  struct Item: Equatable, Hashable, IdentifiableType {
    var identity: Int {
      self.keyword.idx
    }
    var keyword: Keyword
  }
  
//  static let `default`: [FilterSeriesDataSection.Model] = [FilterSeriesDataSection.Model(model: "series", items: [])]
}
