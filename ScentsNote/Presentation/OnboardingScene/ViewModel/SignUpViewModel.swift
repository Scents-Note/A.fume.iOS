//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import RxSwift
import RxRelay

final class SignUpViewModel {
  private weak var coordinator: SignUpCoordinator?
  
  var email = ""
  var nickname = ""
  
  struct Input {
    let emailTextFieldDidEditEvent: Observable<String>
    let nicknameTextFieldDidEditEvent: Observable<String>
//    let nextDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var nextButtonShouldEnable = BehaviorRelay<Bool>(value: false)
    var emailValidationState = BehaviorRelay<EmailValidationState>(value: .empty)
    var nicknameValidationState = BehaviorRelay<NicknameValidationState>(value: .empty)
  }
  
  init(coordinator: SignUpCoordinator?) {
    self.coordinator = coordinator
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    input.emailTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] string in
        self?.email = string
        self?.updateEmailValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.nicknameTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] string in
        self?.nickname = string
        self?.updateNicknameValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    return output
  }
  
  func updateEmailValidationState(output: Output) {
    guard !self.email.isValidEmail() else {
      output.emailValidationState.accept(.success)
      return
    }
    output.nextButtonShouldEnable.accept(true)
  }
  
  func updateNicknameValidationState(output: Output) {
    guard self.email.isValidEmail() else {
      output.nextButtonShouldEnable.accept(false)
      return
    }
    output.nextButtonShouldEnable.accept(true)
  }
}
