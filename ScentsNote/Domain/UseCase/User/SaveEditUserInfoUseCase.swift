//
//  SaveEditUserInfoUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//


final class SaveEditUserInfoUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(userInfo: EditUserInfo) {
    self.userRepository.setUserDefault(key: UserDefaultKey.nickname, value: userInfo.nickname)
    self.userRepository.setUserDefault(key: UserDefaultKey.gender, value: userInfo.gender)
    self.userRepository.setUserDefault(key: UserDefaultKey.birth, value: userInfo.birth)
  }
}
