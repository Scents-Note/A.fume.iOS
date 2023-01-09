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
    let passwordCurrentDidEditEvent: Observable<String>
    let passwordCurrentCheckButtonDidTapEvent: Observable<Void>
    let passwordDidEditEvent: Observable<String>
    let passwordCheckDidEditEvent: Observable<String>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let passwordCurrentState = BehaviorRelay<InputState>(value: .empty)
    let passwordState = BehaviorRelay<InputState>(value: .empty)
    let passwordCheckState = BehaviorRelay<InputState>(value: .empty)
    let canDone = BehaviorRelay<Bool>(value: false)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: ChangePasswordCoordinator?
  private let fetchUserPasswordUseCase: FetchUserPasswordUseCase
  private let changePasswordUseCase: ChangePasswordUseCase
  private let savePasswordUseCase: SavePasswordUseCase
  
  var isNewPasswordSectionShown = false
  private var passwordOld = ""
  private var passwordCurrent = ""
  private var password = ""
  private var passwordCheck = ""
  
  // MARK: - Life Cycle
  init(coordinator: ChangePasswordCoordinator,
       fetchUserPasswordUseCase: FetchUserPasswordUseCase,
       changePasswordUseCase: ChangePasswordUseCase,
       savePasswordUseCase: SavePasswordUseCase) {
    self.coordinator = coordinator
    self.fetchUserPasswordUseCase = fetchUserPasswordUseCase
    self.changePasswordUseCase = changePasswordUseCase
    self.savePasswordUseCase = savePasswordUseCase
  }
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let passwordCurrentState = PublishRelay<InputState>()
    let passwordState = PublishRelay<InputState>()
    let passwordCheckState = PublishRelay<InputState>()
    
    self.bindInput(input: input,
                   passwordCurrentState: passwordCurrentState,
                   passwordState: passwordState,
                   passwordCheckState: passwordCheckState,
                   disposeBag: disposeBag)
    self.bindOutput(output: output,
                    passwordCurrentState: passwordCurrentState,
                    passwordState: passwordState,
                    passwordCheckState: passwordCheckState,
                    disposeBag: disposeBag)
    self.fetchDatas()
    return output
  }
  
  private func bindInput(input: Input,
                         passwordCurrentState: PublishRelay<InputState>,
                         passwordState: PublishRelay<InputState>,
                         passwordCheckState: PublishRelay<InputState>,
                         disposeBag: DisposeBag) {
    
    input.passwordCurrentDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        self?.passwordCurrent = text
        self?.updatePasswordCurrentState(password: text, passwordState: passwordCurrentState)
      })
      .disposed(by: disposeBag)
    
    input.passwordCurrentCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.comparePassword(passwordState: passwordCurrentState)
      })
      .disposed(by: disposeBag)
    
    input.passwordDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        self.password = text
        self.updatePasswordState(password: text, passwordState: passwordState)
        self.updatePasswordCheckState(password: self.passwordCheck, passwordState: passwordCheckState)
      })
      .disposed(by: disposeBag)
    
    input.passwordCheckDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        self?.passwordCheck = text
        self?.updatePasswordCheckState(password: text, passwordState: passwordCheckState)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.changePassword(disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)

  }
  
  private func bindOutput(output: Output,
                          passwordCurrentState: PublishRelay<InputState>,
                          passwordState: PublishRelay<InputState>,
                          passwordCheckState: PublishRelay<InputState>,
                          disposeBag: DisposeBag) {
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
      .subscribe(onNext: { old, pw, pwCheck in
        guard old == .success, pw == .success, pwCheck == .success else {
          output.canDone.accept(false)
          return
        }
        output.canDone.accept(true)
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
  
  private func updatePasswordState(password: String, passwordState: PublishRelay<InputState>) {
    guard password.count > 0 else {
      passwordState.accept(.empty)
      return
    }
    guard password.count >= 4 else {
      passwordState.accept(.wrongFormat)
      return
    }
    guard password != self.passwordOld else {
      passwordState.accept(.duplicate)
      return
    }
    
    passwordState.accept(.success)
  }
  
  private func updatePasswordCheckState(password: String, passwordState: PublishRelay<InputState>) {
    guard self.passwordCheck.count > 0 else {
      passwordState.accept(.empty)
      return
    }
    guard self.password == self.passwordCheck else {
      passwordState.accept(.wrongFormat)
      return
    }
    passwordState.accept(.success)
  }
  
  private func comparePassword(passwordState: PublishRelay<InputState>) {
    let isEqual = self.passwordOld == self.passwordCurrent
    passwordState.accept(isEqual ? .success : .notCorrect)
  }
  
  func toggleNewPasswordShown() {
    self.isNewPasswordSectionShown.toggle()
  }
  
  private func changePassword(disposeBag: DisposeBag) {
    let dto = Password(oldPassword: passwordOld, newPassword: passwordCheck)
    self.changePasswordUseCase.execute(password: dto)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.savePasswordUseCase.execute(password: self.passwordCheck)
        self.coordinator?.finishFlow?()
      })
      .disposed(by: disposeBag)

  }
}
