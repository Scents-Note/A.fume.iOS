//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class SignUpBirthViewModel {
  private weak var coordinator: SignUpCoordinator?
  private let userRepository: UserRepository
  private var signUpInfo: SignUpInfo
  
  var birth = BehaviorRelay<Int>(value: 1990)
  
  struct Input {
    let birthButtonDidTapEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  
  init(coordinator: SignUpCoordinator?, userRepository: UserRepository, signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.userRepository = userRepository
    self.signUpInfo = signUpInfo
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) {
    
    input.birthButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showBirthPopupViewController(with: self?.birth.value ?? 1990)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.signUpInfo.birth = self.birth.value
        self.userRepository.signUp(signUpInfo: self.signUpInfo)
          .subscribe { loginInfo in
            self.userRepository.saveLoginInfo(loginInfo: loginInfo)
            self.coordinator?.finishFlow?()
          } onError: { error in
            Log(error)
          }
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
    
  }
}

