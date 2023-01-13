//
//  SaveLoginInfoUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

final class SaveLoginInfoUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(loginInfo: LoginInfo, email: String?, password: String?) {
    self.userRepository.setUserDefault(key: UserDefaultKey.token, value: loginInfo.token)
    self.userRepository.setUserDefault(key: UserDefaultKey.refreshToken, value: loginInfo.refreshToken)
    self.userRepository.setUserDefault(key: UserDefaultKey.userIdx, value: loginInfo.userIdx)
    self.userRepository.setUserDefault(key: UserDefaultKey.nickname, value: loginInfo.nickname)
    self.userRepository.setUserDefault(key: UserDefaultKey.gender, value: loginInfo.gender)
    self.userRepository.setUserDefault(key: UserDefaultKey.birth, value: loginInfo.birth)
    self.userRepository.setUserDefault(key: UserDefaultKey.isLoggedIn, value: true)
    if let email = email {
      self.userRepository.setUserDefault(key: UserDefaultKey.email, value: email)
    }
    if let password = password {
      self.userRepository.setUserDefault(key: UserDefaultKey.password, value: password)
    }
  }
}
