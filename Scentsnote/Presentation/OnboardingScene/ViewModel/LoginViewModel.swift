//
//  LoginViewModel.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation
import RxSwift
import RxRelay

final class LoginViewModel {
  private weak var coordinator: LoginCoordinator?
  
  private var email = ""
  private var password = ""
  
  struct Input {
    let emailTextFieldDidEditEvent: Observable<String>
    let passwordTextFieldDidEditEvent: Observable<String>
    let signupButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var emailFieldText = BehaviorRelay<String?>(value: "")
    var passwordFieldText = BehaviorRelay<String?>(value: "")
    var doneButtonShouldEnable = BehaviorRelay<Bool>(value: false)

  }

  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    input.emailTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] string in
        self?.email = string
        self?.updateValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.passwordTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] string in
        self?.password = string
        self?.updateValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.signupButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.finish()
      })
      .disposed(by: disposeBag)

    return output
  }
  
  init(coordinator: LoginCoordinator?) {
    self.coordinator = coordinator
  }
  
  func updateValidationState(output: Output) {
    guard self.email.isValidEmail(), self.password.isValidPassword() else {
      output.doneButtonShouldEnable.accept(false)
      return
    }
    output.doneButtonShouldEnable.accept(true)
  }
  
  
}


