//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import RxSwift
import RxRelay

final class SignUpInformationViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let emailTextFieldDidEditEvent = PublishRelay<String>()
    let emailCheckButtonDidTapEvent = PublishRelay<Void>()
    let nicknameTextFieldDidEditEvent = PublishRelay<String>()
    let nicknameCheckButtonDidTapEvent = PublishRelay<Void>()
    let nextButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let hideNicknameSection = BehaviorRelay<Bool>(value: true)
    let emailState = BehaviorRelay<InputState>(value: .empty)
    let nicknameState = BehaviorRelay<InputState>(value: .empty)
    let canDone = BehaviorRelay<Bool>(value: false)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SignUpCoordinator?
  private let checkDuplcateEmailUseCase: CheckDuplicateEmailUseCase
  private let checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var email = ""
  var nickname = ""
  
  init(coordinator: SignUpCoordinator?,
       checkDuplcateEmailUseCase: CheckDuplicateEmailUseCase,
       checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase) {
    self.coordinator = coordinator
    self.checkDuplcateEmailUseCase = checkDuplcateEmailUseCase
    self.checkDuplicateNicknameUseCase = checkDuplicateNicknameUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Transform
  func transform(input: Input, output: Output) {
    let emailState = PublishRelay<InputState>()
    let nicknameState = PublishRelay<InputState>()
    let hideNicknameSection = PublishRelay<Bool>()
    
    self.bindInput(input: input,
                   emailState: emailState,
                   nicknameState: nicknameState,
                   hideNicknameSection: hideNicknameSection)
    self.bindOutput(output: output,
                    emailState: emailState,
                    nicknameState: nicknameState,
                    hideNicknameSection: hideNicknameSection)
  }
  
  func bindInput(input: Input,
                 emailState: PublishRelay<InputState>,
                 nicknameState: PublishRelay<InputState>,
                 hideNicknameSection: PublishRelay<Bool>) {
    input.emailTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] email in
        self?.email = email
        self?.updateEmailState(emailState: emailState)
      })
      .disposed(by: self.disposeBag)
    
    input.emailCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let email = self?.email else { return }
        self?.checkDuplcateEmail(email: email, emailState: emailState, hideNicknameSection: hideNicknameSection)
      })
      .disposed(by: disposeBag)
    
    input.nicknameTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] nickname in
        self?.nickname = nickname
        self?.updateNicknameState(nicknameState: nicknameState)
      })
      .disposed(by: disposeBag)
    
    input.nicknameCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkDuplcateNickname(nickname: self?.nickname, nicknameState: nicknameState)
      })
      .disposed(by: disposeBag)
    
    input.nextButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showSignUpPasswordViewController(with: SignUpInfo(email: self?.email, nickname: self?.nickname))
      })
      .disposed(by: disposeBag)
  }
  
  func bindOutput(output: Output,
                  emailState: PublishRelay<InputState>,
                  nicknameState: PublishRelay<InputState>,
                  hideNicknameSection: PublishRelay<Bool>) {
    
    hideNicknameSection
      .bind(to: output.hideNicknameSection)
      .disposed(by: self.disposeBag)
    
    emailState
      .bind(to: output.emailState)
      .disposed(by: self.disposeBag)
    
    nicknameState
      .bind(to: output.nicknameState)
      .disposed(by: self.disposeBag)
    
    Observable.combineLatest(emailState, nicknameState)
      .subscribe(onNext: { emailState, nicknameState in
        if emailState == .success, nicknameState == .success {
          output.canDone.accept(true)
        } else {
          output.canDone.accept(false)
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Update
  func updateEmailState(emailState: PublishRelay<InputState>) {
    guard self.email.count > 0 else {
      emailState.accept(.empty)
      return
    }
    guard self.email.isValidEmail() else {
      emailState.accept(.wrongFormat)
      return
    }
    emailState.accept(.correctFormat)
  }
  
  func updateNicknameState(nicknameState: PublishRelay<InputState>) {
    guard self.nickname.count > 0 else {
      nicknameState.accept(.empty)
      return
    }
    guard self.nickname.isValidNickname() else {
      nicknameState.accept(.wrongFormat)
      return
    }
    nicknameState.accept(.correctFormat)
  }
  
  func checkDuplcateEmail(email: String?, emailState: PublishRelay<InputState>, hideNicknameSection: PublishRelay<Bool>) {
    guard let email = email else { return }
    self.checkDuplcateEmailUseCase.execute(email: email)
      .subscribe{ _ in
        emailState.accept(.success)
        hideNicknameSection.accept(false)
      } onError: { error in
        emailState.accept(.duplicate)
      }
      .disposed(by: self.disposeBag)
  }
  
  func checkDuplcateNickname(nickname: String?, nicknameState: PublishRelay<InputState>) {
    guard let nickname = nickname else { return }
    self.checkDuplicateNicknameUseCase.execute(nickname: nickname)
      .subscribe { _ in
        nicknameState.accept(.success)
      } onError: { error in
        nicknameState.accept(.duplicate)
      }
      .disposed(by: self.disposeBag)
  }
}
