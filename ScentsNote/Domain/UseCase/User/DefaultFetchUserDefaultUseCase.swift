//
//  FetchUserDefaultUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import RxSwift

protocol FetchUserDefaultUseCase {
  func execute<T>(key: String) -> T?
}

final class DefaultFetchUserDefaultUseCase: FetchUserDefaultUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute<T>(key: String) -> T? {
    self.userRepository.fetchUserDefaults(key: key)
  }
}
