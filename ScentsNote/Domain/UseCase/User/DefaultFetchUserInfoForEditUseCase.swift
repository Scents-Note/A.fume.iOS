//
//  DefaultFetchUserInfoForEditUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import RxSwift

protocol FetchUserInfoForEditUseCase {
  func execute() -> Observable<EditUserInfo>
}

final class DefaultFetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() -> Observable<EditUserInfo> {
    let nickname = self.userRepository.fetchUserDefaults(key: UserDefaultKey.nickname) ?? ""
    let gender: String? = self.userRepository.fetchUserDefaults(key: UserDefaultKey.gender)
    let birth: Int? = self.userRepository.fetchUserDefaults(key: UserDefaultKey.birth)
    let userInfo = EditUserInfo(nickname: nickname, gender: gender, birth: birth)
    return Observable.just(userInfo)
  }
}
