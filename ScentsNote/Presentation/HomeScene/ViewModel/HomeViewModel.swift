//
//  HomeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import Foundation

final class HomeViewModel {
  weak var coordinator: HomeCoordinator?
  
  init(coordinator: HomeCoordinator) {
    self.coordinator = coordinator
  }
}
