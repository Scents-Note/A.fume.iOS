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
  
  struct Input {
    let emailTextFieldDidEditEvent: Observable<String>
    let passwordTextFieldDidEditEvent: Observable<String>
    let loginButtonDidTapEvent: Observable<Void>
    let signupButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let emailFieldText = BehaviorRelay<String?>(value: "")
    let passwordFieldText = BehaviorRelay<String?>(value: "")
    let doneButtonShouldEnable = BehaviorRelay<Bool>(value: false)
    let notCorrect = PublishRelay<Void>()
  }
  
  private weak var coordinator: LoginCoordinator?
  private let loginUseCase: LoginUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  
  private var email = ""
  private var password = ""
  
  init(coordinator: LoginCoordinator?,
       loginUseCase: LoginUseCase,
       saveLoginInfoUseCase: SaveLoginInfoUseCase) {
    self.coordinator = coordinator
    self.loginUseCase = loginUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
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
        self.loginUseCase.execute(email: self.email, password: self.password)
          .subscribe { loginInfo in
            self.saveLoginInfoUseCase.execute(loginInfo: loginInfo, email: self.email, password: self.password)
            self.coordinator?.finishFlow?()
          } onError: { error in
            output.notCorrect.accept(())
          }
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.signupButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSignUpFlow?()
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


