//
//  TabBarPage.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import Foundation

enum TabBarPage: String, CaseIterable {
    case home, search, mypage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .search
        case 2: self = .mypage
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .search: return 1
        case .mypage: return 2
        }
    }
    
    func tabIconName() -> String {
      switch self {
      case .home: return "homeActive"
      case .search: return "searchInactive"
      case .mypage: return "mypageInactive"
      }
    }
}
