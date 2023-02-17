//
//  DefaultChangePasswordUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

protocol ChangePasswordUseCase {
  func execute(password: Password) -> Observable<String>
}

import RxSwift

final class DefaultChangePasswordUseCase: ChangePasswordUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(password: Password) -> Observable<String> {
    self.userRepository.changePassword(password: password)
  }
}
