//
//  SearchFilterSeriesSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import RxDataSources

struct FilterSeriesDataSection {
  typealias Model = AnimatableSectionModel<String, Item>
  
  struct Item: Hashable, IdentifiableType {
    var identity: String {
      self.ingredient.id
    }
    var ingredient: FilterIngredient
  }
  
  static let `default`: [FilterSeriesDataSection.Model] = [FilterSeriesDataSection.Model(model: "series", items: [])]
}
