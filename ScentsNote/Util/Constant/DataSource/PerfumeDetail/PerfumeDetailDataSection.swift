//
//  PerfumeDetailDataSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import RxDataSources

struct PerfumeDetailDataSection {
  typealias Model = AnimatableSectionModel<Section, Item>
  
  enum Section: Int, Equatable, Hashable, IdentifiableType {
    var identity: Int {
      hashValue
    }
    
    case title = 0
    case content = 1
  }
  
  enum Item: Equatable, Hashable, IdentifiableType {
    var identity: Int {
      hashValue
    }
    
    case title(PerfumeDetail)
    case content(PerfumeDetail)
  }
  
//  static var initialSectionDatas: [HomeDataSection.Model] {
//    return [HomeDataSection.Model(model: HomeSection.title, items: [HomeDataSection.HomeItem.title]),
//            HomeDataSection.Model(model: HomeSection.recommendation, items: []),
//            HomeDataSection.Model(model: HomeSection.popularity, items: []),
//            HomeDataSection.Model(model: HomeSection.recent, items: []),
//            HomeDataSection.Model(model: HomeSection.new, items: []),
//            HomeDataSection.Model(model: HomeSection.more, items: [HomeDataSection.HomeItem.more])]
//  }
}
