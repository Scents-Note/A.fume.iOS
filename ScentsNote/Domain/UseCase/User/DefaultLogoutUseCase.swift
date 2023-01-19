//
//  DefaultLogoutUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import RxSwift

protocol LogoutUseCase {
  func execute()
}

final class DefaultLogoutUseCase: LogoutUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() {
    for key in UserDefaultKey.list {
      self.userRepository.removeUserDefault(key: key)
    }
  }
}
