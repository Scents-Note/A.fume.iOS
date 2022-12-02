//
//  FetchUserPasswordUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import Foundation

// TODO: 유저 정보 통합. param으로 정보 가져오기
final class FetchUserPasswordUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() -> String {
    self.userRepository.fetchUserDefaults(key: UserDefaultKey.password) ?? "test"
  }
}
