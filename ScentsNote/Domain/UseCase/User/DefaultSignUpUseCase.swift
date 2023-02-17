//
//  DefaultSignUpUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/20.
//

import RxSwift

protocol SignUpUseCase {
  func execute(signUpInfo: SignUpInfo) -> Observable<LoginInfo>
}

final class DefaultSignUpUseCase: SignUpUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(signUpInfo: SignUpInfo) -> Observable<LoginInfo> {
    self.userRepository.signUp(signUpInfo: signUpInfo)
  }
  
}
