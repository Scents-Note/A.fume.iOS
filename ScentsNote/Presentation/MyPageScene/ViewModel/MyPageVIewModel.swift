//
//  MyPageVIewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import Foundation

final class MyPageViewModel {
  weak var coordinator: MyPageCoordinator?
  
  init(coordinator: MyPageCoordinator) {
    self.coordinator = coordinator
  }
}
