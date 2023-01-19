//
//  DefaultCheckDuplicateNicknameUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import RxSwift

protocol CheckDuplicateNicknameUseCase {
  func execute(nickname: String) -> Observable<Bool>
}

final class DefaultCheckDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(nickname: String) -> Observable<Bool> {
    self.userRepository.checkDuplicateNickname(nickname: nickname)
  }
}
