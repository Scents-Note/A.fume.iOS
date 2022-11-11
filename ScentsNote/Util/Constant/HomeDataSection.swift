//
//  SectionTBD.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/09.
//

import RxDataSources

struct HomeDataSection {
  typealias Model = AnimatableSectionModel<HomeSection, HomeItem>
  
  enum HomeSection: Int, Equatable, Hashable, IdentifiableType {
    var identity: Int {
      hashValue
    }
    
    case title = 0
    case recommendation = 1
    case popularity = 2
    case recent = 3
    case new = 4
    case more = 5
  }
  
  enum HomeItem: Equatable, Hashable, IdentifiableType {
    var identity: Int {
      hashValue
    }
    
    case title
    case recommendation([Perfume])
    case popularity(Perfume)
    case recent(Perfume)
    case new(Perfume)
    case more
  }
  
  static var initialSectionDatas: [HomeDataSection.Model] {
    return [HomeDataSection.Model(model: HomeSection.title, items: [HomeDataSection.HomeItem.title]),
            HomeDataSection.Model(model: HomeSection.recommendation, items: []),
            HomeDataSection.Model(model: HomeSection.popularity, items: []),
            HomeDataSection.Model(model: HomeSection.recent, items: []),
            HomeDataSection.Model(model: HomeSection.new, items: []),
            HomeDataSection.Model(model: HomeSection.more, items: [HomeDataSection.HomeItem.more])]
  }
}
