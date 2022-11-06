//
//  SearchViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import Foundation

final class SearchViewModel {
  weak var coordinator: SearchCoordinator?
  
  init(coordinator: SearchCoordinator) {
    self.coordinator = coordinator
  }
}
