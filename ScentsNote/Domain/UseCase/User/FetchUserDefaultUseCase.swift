//
//  FetchUserDefaultUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import RxSwift

final class FetchUserDefaultUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute<T>(key: String) -> T? {
    self.userRepository.fetchUserDefaults(key: key)
  }
}
