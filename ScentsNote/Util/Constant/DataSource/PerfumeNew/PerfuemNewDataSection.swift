//
//  PerfuemNewDataSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import RxDataSources

struct PerfumeNewDataSection {
  typealias Model = AnimatableSectionModel<String, Item>
  
  struct Item: Equatable, Hashable, IdentifiableType {
    var identity: Int {
      self.perfume.perfumeIdx
    }
    var perfume: Perfume
  }
}
