//
//  SignUpPasswordViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
//

import RxSwift
import RxRelay

final class SignUpPasswordViewModel {
  
  struct Input {
    let passwordTextFieldDidEditEvent = PublishRelay<String>()
    let passwordCheckTextFieldDidEditEvent = PublishRelay<String>()
    let nextButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let passwordState = BehaviorRelay<InputState>(value: .empty)
    let passwordCheckState = BehaviorRelay<InputState>(value: .empty)
    let hidePasswordCheckSection = BehaviorRelay<Bool>(value: true)
    let canDone = BehaviorRelay<Bool>(value: false)
  }
  
  private weak var coordinator: SignUpCoordinator?
  private var signUpInfo: SignUpInfo
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var password = ""
  var passwordCheck = ""
  
  init(coordinator: SignUpCoordinator?, signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.signUpInfo = signUpInfo
    
    self.transform(input: self.input, output: self.output)
  }
  
  func transform(input: Input, output: Output){
    let passwordState = PublishRelay<InputState>()
    let passwordCheckState = PublishRelay<InputState>()
    let hidePasswordCheckSection = PublishRelay<Bool>()
    
    self.bindInput(input: input,
                   passwordState: passwordState,
                   passwordCheckState: passwordCheckState,
                   hidePasswordCheckSection: hidePasswordCheckSection)
    
    self.bindOutput(output: output,
                    passwordState: passwordState,
                    passwordCheckState: passwordCheckState,
                    hidePasswordCheckSection: hidePasswordCheckSection)
  }
  
  private func bindInput(input: Input,
                         passwordState: PublishRelay<InputState>,
                         passwordCheckState:  PublishRelay<InputState>,
                         hidePasswordCheckSection: PublishRelay<Bool>) {
    
    input.passwordTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] password in
        self?.password = password
        self?.updatePasswordState(password: password, passwordState: passwordState, hidePasswordCheckSection: hidePasswordCheckSection)
      })
      .disposed(by: self.disposeBag)
    
    input.passwordCheckTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] passwordCheck in
        self?.passwordCheck = passwordCheck
        self?.updatePasswordCheckState(password: self?.password, passwordCheck: passwordCheck, passwordCheckState: passwordCheckState)
      })
      .disposed(by: self.disposeBag)
    
    input.nextButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.signUpInfo.password = self?.passwordCheck
        guard let signupInfo = self?.signUpInfo else { return }
        self?.coordinator?.showSignUpGenderViewController(with: signupInfo)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output,
                          passwordState: PublishRelay<InputState>,
                          passwordCheckState: PublishRelay<InputState>,
                          hidePasswordCheckSection: PublishRelay<Bool>) {
    passwordState
      .bind(to: output.passwordState)
      .disposed(by: self.disposeBag)
    
    passwordCheckState
      .bind(to: output.passwordCheckState)
      .disposed(by: self.disposeBag)
    
    hidePasswordCheckSection
      .bind(to: output.hidePasswordCheckSection)
      .disposed(by: self.disposeBag)
    
    Observable.combineLatest(passwordState, passwordCheckState)
      .subscribe(onNext: { passwordState, passwordCheckState in
        if passwordState == .success, passwordCheckState == .success {
          output.canDone.accept(true)
        } else {
          output.canDone.accept(false)
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  private func updatePasswordState(password: String, passwordState: PublishRelay<InputState>, hidePasswordCheckSection: PublishRelay<Bool>) {
    guard self.password.count > 0 else {
      passwordState.accept(.empty)
      return
    }
    guard self.password.count >= 4 else {
      passwordState.accept(.wrongFormat)
      return
    }
    passwordState.accept(.success)
    hidePasswordCheckSection.accept(false)
  }
  
  private func updatePasswordCheckState(password: String?, passwordCheck: String, passwordCheckState: PublishRelay<InputState>) {
    guard self.passwordCheck.count > 0 else {
      passwordCheckState.accept(.empty)
      return
    }
    guard self.password == self.passwordCheck else {
      passwordCheckState.accept(.wrongFormat)
      return
    }
    passwordCheckState.accept(.success)
    
  }
}
