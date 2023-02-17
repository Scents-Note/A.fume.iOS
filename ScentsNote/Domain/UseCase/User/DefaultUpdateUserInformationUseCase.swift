//
//  DefaultUpdateUserInformationUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//


import RxSwift

protocol UpdateUserInformationUseCase {
  func execute(userInfo: EditUserInfo) -> Observable<EditUserInfo>
}

final class DefaultUpdateUserInformationUseCase: UpdateUserInformationUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(userInfo: EditUserInfo) -> Observable<EditUserInfo> {
    let userIdx = self.userRepository.fetchUserDefaults(key: UserDefaultKey.userIdx) ?? 0
    return self.userRepository.updateUserInfo(userIdx: userIdx, userInfo: userInfo)
  }
}
