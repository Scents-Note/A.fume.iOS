//
//  DefaultSavePasswordUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

protocol SavePasswordUseCase {
  func execute(password: String)
}

final class DefaultSavePasswordUseCase: SavePasswordUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(password: String) {
    self.userRepository.setUserDefault(key: UserDefaultKey.password, value: password)
  }
}
