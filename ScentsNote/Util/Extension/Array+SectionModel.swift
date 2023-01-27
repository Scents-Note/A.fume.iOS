//
//  Array+SectionModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/27.
//

import Foundation

extension Array where Element == SearchKeyword {
  func toSectionModel() -> [KeywordDataSection.Model] {
    let item = self.map { KeywordDataSection.Item(keyword: $0) }
    return [KeywordDataSection.Model(model: "keyword", items: item)]
  }
}

extension Array where Element == Perfume {
  func toSectionModel() -> [PerfumeDataSection.Model] {
    let item = self.map { PerfumeDataSection.Item(perfume: $0) }
    return [PerfumeDataSection.Model(model: "perfume", items: item)]
  }
}

