//
//  SectionTBD.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/09.
//

import RxDataSources

struct HomeDataSection {
  typealias Model = SectionModel<HomeSection, HomeItem>
  
  enum HomeSection: Int, Equatable {
    case title = 0
    case recommendation = 1
    case popularity = 2
    case recent = 3
    case new = 4
    case more = 5
  }
  
  enum HomeItem: Equatable {
    case title
    case recommendation([Perfume])
    case popularity(Perfume)
    case recent(Perfume)
    case new(Perfume)
    case more
  }
}
