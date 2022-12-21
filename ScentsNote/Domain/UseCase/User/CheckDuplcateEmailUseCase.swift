//
//  CheckDuplcateEmailUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/20.
//

import RxSwift

final class CheckDuplcateEmailUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(email: String) -> Observable<Bool> {
    self.userRepository.checkDuplicateEmail(email: email)
  }
}
