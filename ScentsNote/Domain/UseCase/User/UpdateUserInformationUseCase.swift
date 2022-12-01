//
//  UpdateUserInformationUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//


import RxSwift

final class UpdateUserInformationUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(userInfo: UserInfo) -> Observable<UserInfo> {
    let userIdx = self.userRepository.fetchUserIdx() ?? 0
    return self.userRepository.updateUserInfo(userIdx: userIdx, userInfo: userInfo)
  }
}
