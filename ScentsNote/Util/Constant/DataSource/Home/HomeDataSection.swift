//
//  SectionTBD.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/09.
//

import RxDataSources

struct HomeDataSection {
  typealias Model = AnimatableSectionModel<HomeSection, HomeItem>
  
  struct Content: Hashable {
    let title: String
    let content: String
    
    static var `default` = Content(title: "", content: "")
  }
  
  enum HomeSection: Hashable, IdentifiableType {
    var identity: Int {
      hashValue
    }
    
    case title
    case recommendation(Content)
    case popularity(Content)
    case recent(Content)
    case new(Content)
    case more
    
    func hasSameCaseAs(_ type: Self) -> Bool {
      switch self {
      case .title: if case .title = type { return true }
      case .recommendation: if case .recommendation = type { return true }
      case .popularity: if case .popularity = type { return true }
      case .recent: if case .recent = type { return true }
      case .new: if case .new = type { return true }
      case .more: if case .more = type { return true }
      }
      return false
    }
  }
  
  enum HomeItem: Hashable, IdentifiableType {
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
  
  
  static var `default`: [HomeDataSection.Model] {
    return [HomeDataSection.Model(model: HomeSection.title, items: [HomeDataSection.HomeItem.title]),
            HomeDataSection.Model(model: HomeSection.recommendation(.default), items: []),
            HomeDataSection.Model(model: HomeSection.popularity(.default), items: []),
            HomeDataSection.Model(model: HomeSection.recent(.default), items: []),
            HomeDataSection.Model(model: HomeSection.new(.default), items: []),
            HomeDataSection.Model(model: HomeSection.more, items: [HomeDataSection.HomeItem.more])]
  }
}
