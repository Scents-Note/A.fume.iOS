//
//  SignUpPasswordViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
//

import RxSwift
import RxRelay

final class SignUpPasswordViewModel {
  private weak var coordinator: SignUpCoordinator?
  private let userRepository: UserRepository
  private var signUpInfo: SignUpInfo
  
  private var password = ""
  private var passwordCheck = ""
  
  struct Input {
    let passwordTextFieldDidEditEvent: Observable<String>
    let passwordCheckTextFieldDidEditEvent: Observable<String>
    let nextButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var passwordValidationState = BehaviorRelay<InputState>(value: .empty)
    var passwordCheckValidationState = BehaviorRelay<InputState>(value: .empty)
  }
  
  init(coordinator: SignUpCoordinator?, userRepository: UserRepository, signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.userRepository = userRepository
    self.signUpInfo = signUpInfo
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    input.passwordTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] password in
        self?.password = password
        self?.updatePasswordValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.passwordCheckTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] passwordCheck in
        self?.passwordCheck = passwordCheck
        self?.updatePasswordCheckValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.nextButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.signUpInfo.password = self.passwordCheck
        self.coordinator?.showSignUpGenderViewController(with: self.signUpInfo)
      })
      .disposed(by: disposeBag)
    
    return output
  }
}

extension SignUpPasswordViewModel {
  private func updatePasswordValidationState(output: Output) {
    guard self.password.count > 0 else {
      output.passwordValidationState.accept(.empty)
      return
    }
    guard self.password.count >= 4 else {
      output.passwordValidationState.accept(.wrongFormat)
      return
    }
    output.passwordValidationState.accept(.success)
  }
  
  private func updatePasswordCheckValidationState(output: Output) {
    guard self.passwordCheck.count > 0 else {
      output.passwordCheckValidationState.accept(.empty)
      return
    }
    guard self.password == self.passwordCheck else {
      output.passwordCheckValidationState.accept(.wrongFormat)
      return
    }
    output.passwordCheckValidationState.accept(.success)
    
  }
}
