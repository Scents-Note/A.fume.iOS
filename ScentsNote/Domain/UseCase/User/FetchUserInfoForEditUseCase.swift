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
    let nickname = self.userRepository.fetchUserDefaults(key: UserDefaultKey.nickname) ?? ""
    let gender = self.userRepository.fetchUserDefaults(key: UserDefaultKey.gender) ?? "MAN"
    let birth = self.userRepository.fetchUserDefaults(key: UserDefaultKey.birth) ?? 1990
    let userInfo = UserInfo(nickname: nickname, gender: gender, birth: birth)
    return Observable.just(userInfo)
  }
}
