//
//  LoginUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import RxSwift

final class LoginUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(email: String, password: String) -> Observable<LoginInfo> {
    self.userRepository.login(email: email, password: password)
  }
  
  // TODO: 임시 자동로그인
  func execute() -> Observable<LoginInfo> {
    let isLoggedIn = self.userRepository.fetchUserDefaults(key: UserDefaultKey.isLoggedIn) ?? false
    if isLoggedIn {
      let email = self.userRepository.fetchUserDefaults(key: UserDefaultKey.email) ?? ""
      let password = self.userRepository.fetchUserDefaults(key: UserDefaultKey.password) ?? ""
      return self.userRepository.login(email: "Testemr1@naver.com", password: "test")
    } else {
      return Observable.just(LoginInfo(userIdx: -1, token: "", refreshToken: ""))
    }
  }
}
