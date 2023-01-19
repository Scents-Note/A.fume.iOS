//
//  SearchFilterSeriesSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import RxDataSources

struct FilterSeriesDataSection {
  typealias Model = AnimatableSectionModel<String, Item>
  
  struct Item: Equatable, IdentifiableType {
    var identity: Int {
      self.ingredient.idx
    }
    var ingredient: FilterIngredient
  }
  
  static let `default`: [FilterSeriesDataSection.Model] = [FilterSeriesDataSection.Model(model: "series", items: [])]
}
