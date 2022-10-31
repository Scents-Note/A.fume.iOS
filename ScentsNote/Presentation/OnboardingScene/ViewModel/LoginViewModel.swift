//
//  LoginViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation
import RxSwift
import RxRelay
import Moya


final class LoginViewModel {
  private weak var coordinator: LoginCoordinator?
  private let userRepository: UserRepository
  
  private var email = ""
  private var password = ""
  
  init(coordinator: LoginCoordinator?, userRepository: UserRepository) {
    self.coordinator = coordinator
    self.userRepository = userRepository
  }
  
  struct Input {
    let emailTextFieldDidEditEvent: Observable<String>
    let passwordTextFieldDidEditEvent: Observable<String>
    let loginButtonDidTapEvent: Observable<Void>
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
    
    input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.userRepository.login(email: self.email, password: self.password, completion: { result in
          result.success { loginInfo in
            print("User Log: loginInfo \(loginInfo)")
          }.catch { error in
            print("User Log: error \(error)")
          }
        })
      })
      .disposed(by: disposeBag)
    
    input.signupButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.onSignUpFlow?()
      })
      .disposed(by: disposeBag)
    
    return output
  }
  
  func updateValidationState(output: Output) {
    guard self.email.isValidEmail(), self.password.isValidPassword() else {
      output.doneButtonShouldEnable.accept(false)
      return
    }
    output.doneButtonShouldEnable.accept(true)
  }
  
  
}


