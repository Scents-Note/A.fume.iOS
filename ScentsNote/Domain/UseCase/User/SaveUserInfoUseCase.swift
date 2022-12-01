//
//  SaveUserInfoUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//


final class SaveUserInfoUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(userInfo: UserInfo) {
    self.userRepository.saveUserInfo(userInfo: userInfo)
  }
}
