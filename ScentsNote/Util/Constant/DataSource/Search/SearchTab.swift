//
//  SearchTab.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

struct SearchTab {
  let name: String
  let count: Int
  
  static let `default`: [SearchTab] = [SearchTab(name: "계열", count: 0),
                                       SearchTab(name: "브랜드", count: 0),
                                       SearchTab(name: "키워드", count: 0)]
}
