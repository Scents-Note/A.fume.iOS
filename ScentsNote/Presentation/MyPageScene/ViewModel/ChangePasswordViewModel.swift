//
//  ChangePasswordViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import RxSwift
import RxRelay

final class ChangePasswordViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let passwordCurrentDidEditEvent = PublishRelay<String>()
    let passwordCurrentCheckButtonDidTapEvent = PublishRelay<Void>()
    let passwordDidEditEvent = PublishRelay<String>()
    let passwordCheckDidEditEvent = PublishRelay<String>()
    let doneButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let passwordCurrentState = BehaviorRelay<InputState>(value: .empty)
    let showPasswordSection = BehaviorRelay<Bool>(value: false)
    let passwordState = BehaviorRelay<InputState>(value: .empty)
    let passwordCheckState = BehaviorRelay<InputState>(value: .empty)
    let canDone = BehaviorRelay<Bool>(value: false)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: ChangePasswordCoordinator?
  private let fetchUserPasswordUseCase: FetchUserPasswordUseCase
  private let changePasswordUseCase: ChangePasswordUseCase
  private let savePasswordUseCase: SavePasswordUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var isNewPasswordSectionShown = false
  var passwordOld = ""
  var passwordCurrent = ""
  var password = ""
  var passwordCheck = ""
  
  // MARK: - Life Cycle
  init(coordinator: ChangePasswordCoordinator,
       fetchUserPasswordUseCase: FetchUserPasswordUseCase,
       changePasswordUseCase: ChangePasswordUseCase,
       savePasswordUseCase: SavePasswordUseCase) {
    self.coordinator = coordinator
    self.fetchUserPasswordUseCase = fetchUserPasswordUseCase
    self.changePasswordUseCase = changePasswordUseCase
    self.savePasswordUseCase = savePasswordUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let passwordCurrentState = PublishRelay<InputState>()
    let passwordState = PublishRelay<InputState>()
    let passwordCheckState = PublishRelay<InputState>()
    let canDone = PublishRelay<Bool>()
    
    self.bindInput(input: input,
                   passwordCurrentState: passwordCurrentState,
                   passwordState: passwordState,
                   passwordCheckState: passwordCheckState)
    
    self.bindOutput(output: output,
                    passwordCurrentState: passwordCurrentState,
                    passwordState: passwordState,
                    passwordCheckState: passwordCheckState,
                    canDone: canDone)
    
    self.fetchDatas()
  }
  
  private func bindInput(input: Input,
                         passwordCurrentState: PublishRelay<InputState>,
                         passwordState: PublishRelay<InputState>,
                         passwordCheckState: PublishRelay<InputState>) {
    
    input.passwordCurrentDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        self?.passwordCurrent = text
        self?.updatePasswordCurrentState(password: text, passwordState: passwordCurrentState)
      })
      .disposed(by: disposeBag)
    
    input.passwordCurrentCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.comparePassword(passwordOld: self?.passwordOld, passwordCurrent: self?.passwordCurrent, passwordState: passwordCurrentState)
      })
      .disposed(by: disposeBag)
    
    input.passwordDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        self?.password = text
        self?.updatePasswordState(password: text, passwordCurrent: self?.passwordCurrent, passwordState: passwordState)
        self?.updatePasswordCheckState(password: text, passwordCheck: self?.passwordCheck, passwordState: passwordCheckState)
      })
      .disposed(by: disposeBag)
    
    input.passwordCheckDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        self?.passwordCheck = text
        self?.updatePasswordCheckState(password: self?.password, passwordCheck: text, passwordState: passwordCheckState)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.changePassword(passwordCheck: self?.passwordCheck)
      })
      .disposed(by: disposeBag)

  }
  
  private func bindOutput(output: Output,
                          passwordCurrentState: PublishRelay<InputState>,
                          passwordState: PublishRelay<InputState>,
                          passwordCheckState: PublishRelay<InputState>,
                          canDone: PublishRelay<Bool>) {
    passwordCurrentState
      .bind(to: output.passwordCurrentState)
      .disposed(by: disposeBag)
    
    passwordState
      .bind(to: output.passwordState)
      .disposed(by: disposeBag)
    
    passwordCheckState
      .bind(to: output.passwordCheckState)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(passwordCurrentState, passwordState, passwordCheckState)
      .subscribe(onNext: { [weak self] pwCurrent, pw, pwCheck in
        self?.updateCanDone(passwordCurrent: pwCurrent,
                           password: pw,
                           passwordCheck: pwCheck,
                          canDone: canDone)
        
        
      })
      .disposed(by: disposeBag)

  }
  
  private func fetchDatas() {
    let password = self.fetchUserPasswordUseCase.execute()
    self.passwordOld = password
  }
  
  private func updatePasswordCurrentState(password: String, passwordState: PublishRelay<InputState>) {
    guard password.count > 0 else {
      passwordState.accept(.empty)
      return
    }
    guard password.count >= 4 else {
      passwordState.accept(.wrongFormat)
      return
    }
    passwordState.accept(.correctFormat)
  }
  
  private func updatePasswordState(password: String, passwordCurrent: String?, passwordState: PublishRelay<InputState>) {
    guard let passwordCurrent = passwordCurrent else { return }
    
    guard password.count > 0 else {
      passwordState.accept(.empty)
      return
    }
    guard password.count >= 4 else {
      passwordState.accept(.wrongFormat)
      return
    }
    guard password != passwordCurrent else {
      passwordState.accept(.duplicate)
      return
    }
    passwordState.accept(.success)
  }
  
  private func updatePasswordCheckState(password: String?, passwordCheck: String?, passwordState: PublishRelay<InputState>) {
    guard let password = password, let passwordCheck = passwordCheck else { return }
    
    guard self.passwordCheck.count > 0 else {
      passwordState.accept(.empty)
      return
    }
    guard password == passwordCheck else {
      passwordState.accept(.wrongFormat)
      return
    }
    passwordState.accept(.success)
  }
  
  private func updateCanDone(passwordCurrent: InputState,
                             password: InputState,
                             passwordCheck: InputState,
                             canDone: PublishRelay<Bool>) {
    
    guard passwordCheck != .empty else {
      return
    }
    
    guard passwordCurrent == .success, password == .success, passwordCheck == .success else {
      output.canDone.accept(false)
      return
    }
    
    output.canDone.accept(true)
    
  }
  
  private func comparePassword(passwordOld: String?, passwordCurrent: String?, passwordState: PublishRelay<InputState>) {
    let isEqual = passwordOld == passwordCurrent
    passwordState.accept(isEqual ? .success : .notCorrect)
  }
  
  private func changePassword(passwordCheck: String?) {
    guard let passwordCheck = passwordCheck else { return }
    let dto = Password(oldPassword: passwordOld, newPassword: passwordCheck)
    self.changePasswordUseCase.execute(password: dto)
      .subscribe(onNext: { [weak self] _ in
        self?.savePasswordUseCase.execute(password: passwordCheck)
        self?.coordinator?.finishFlow?()
      })
      .disposed(by: self.disposeBag)
  }
  
  func toggleNewPasswordShown() {
    self.isNewPasswordSectionShown = true
  }
}
