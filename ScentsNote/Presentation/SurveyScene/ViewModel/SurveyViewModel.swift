//
//  SurveyViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import Foundation

final class SurveyViewModel {
  private weak var coordinator: SurveyCoordinator?
  private let userRepository: UserRepository
  
  init(coordinator: SurveyCoordinator?, userRepository: UserRepository) {
    self.coordinator = coordinator
    self.userRepository = userRepository
  }
}
