//
//  FetchUserInfoForEditUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import RxSwift

final class FetchUserInfoForEditUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() -> Observable<UserInfo> {
    let nickname = self.userRepository.fetchUserNickname() ?? ""
    let gender = self.userRepository.fetchUserGender() ?? "MAN"
    let birth = self.userRepository.fetchUserBirth() ?? 1990
    let userInfo = UserInfo(nickname: nickname, gender: gender, birth: birth)
    return Observable.just(userInfo)
  }
}
