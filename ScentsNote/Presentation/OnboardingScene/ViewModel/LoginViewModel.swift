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
    let emailTextFieldDidEditEvent = PublishRelay<String>()
    let passwordTextFieldDidEditEvent = PublishRelay<String>()
    let loginButtonDidTapEvent = PublishRelay<Void>()
    let signupButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let canDone = BehaviorRelay<Bool>(value: false)
    let notCorrect = PublishRelay<Void>()
  }
  
  private weak var coordinator: LoginCoordinator?
  private let loginUseCase: LoginUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  
  var email = ""
  var password = ""
  
  init(coordinator: LoginCoordinator?,
       loginUseCase: LoginUseCase,
       saveLoginInfoUseCase: SaveLoginInfoUseCase) {
    self.coordinator = coordinator
    self.loginUseCase = loginUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  func transform(input: Input, output: Output) {
    let canDone = PublishRelay<Bool>()
    let notCorrect = PublishRelay<Void>()
    
    self.bindInput(input: input, canDone: canDone, notCorrect: notCorrect)
    self.bindOutput(output: output, canDone: canDone, notCorrect: notCorrect)
  }
  
  func bindInput(input: Input, canDone: PublishRelay<Bool>, notCorrect: PublishRelay<Void>) {
    input.emailTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] email in
        self?.email = email
        self?.updateValidationState(email: email, password: self?.password, canDone: canDone)
      })
      .disposed(by: self.disposeBag)
    
    input.passwordTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] password in
        self?.password = password
        self?.updateValidationState(email: self?.email, password: password, canDone: canDone)
      })
      .disposed(by: self.disposeBag)
    
    input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let email = self?.email, let password = self?.password else { return }
        self?.loginUseCase.execute(email: email, password: password)
          .subscribe { loginInfo in
            self?.saveLoginInfoUseCase.execute(loginInfo: loginInfo, email: email, password: password)
            self?.coordinator?.finishFlow?()
          } onError: { error in
            notCorrect.accept(())
          }
          .disposed(by: self?.disposeBag ?? DisposeBag())
      })
      .disposed(by: self.disposeBag)
    
    input.signupButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSignUpFlow?()
      })
      .disposed(by: self.disposeBag)
  }
  
  func bindOutput(output: Output, canDone: PublishRelay<Bool>, notCorrect: PublishRelay<Void>) {
    canDone
      .bind(to: output.canDone)
      .disposed(by: self.disposeBag)
    
    notCorrect
      .bind(to: output.notCorrect)
      .disposed(by: self.disposeBag)
  }
  
  func updateValidationState(email: String?, password: String?, canDone: PublishRelay<Bool>) {
    guard let email = email, let password = password else { return }
    
    guard email.isValidEmail(), password.isValidPassword() else {
      canDone.accept(false)
      return
    }
    canDone.accept(true)
  }
}


