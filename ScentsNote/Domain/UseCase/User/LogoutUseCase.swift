//
//  LogoutUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import RxSwift

final class LogoutUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() {
    self.userRepository.logout()
  }
}
