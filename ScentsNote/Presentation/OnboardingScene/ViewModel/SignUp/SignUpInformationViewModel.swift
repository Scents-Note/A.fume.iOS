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
    let emailTextFieldDidEditEvent: Observable<String>
    let emailCheckButtonDidTapEvent: Observable<Void>
    let nicknameTextFieldDidEditEvent: Observable<String>
    let nicknameCheckButtonDidTapEvent: Observable<Void>
    let nextButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var emailValidationState = BehaviorRelay<InputState>(value: .empty)
    var nicknameValidationState = BehaviorRelay<InputState>(value: .empty)
  }
  
  // MARK: - Vars & Lets
  
  private weak var coordinator: SignUpCoordinator?
  private let checkDuplcateEmailUseCase: CheckDuplcateEmailUseCase
  private let checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase
  
  var email = ""
  var nickname = ""
  
  init(coordinator: SignUpCoordinator?,
       checkDuplcateEmailUseCase: CheckDuplcateEmailUseCase,
       checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase) {
    self.coordinator = coordinator
    self.checkDuplcateEmailUseCase = checkDuplcateEmailUseCase
    self.checkDuplicateNicknameUseCase = checkDuplicateNicknameUseCase
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    input.emailTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] string in
        self?.email = string
        self?.updateEmailValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.emailCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let email = self?.email else { return }
        self?.checkDuplcateEmailUseCase.execute(email: email)
          .subscribe{ _ in
            output.emailValidationState.accept(.success)
          } onError: { error in
            output.emailValidationState.accept(.duplicate)
          }
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.nicknameTextFieldDidEditEvent
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] nickname in
        self?.nickname = nickname
        self?.updateNicknameValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.nicknameCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let nickname = self?.nickname else { return }
        self?.checkDuplicateNicknameUseCase.execute(nickname: nickname)
          .subscribe { _ in
            output.nicknameValidationState.accept(.success)
          } onError: { error in
              output.nicknameValidationState.accept(.duplicate)
          }
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.nextButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showSignUpPasswordViewController(with: SignUpInfo(email: self?.email, nickname: self?.nickname))
      })
      .disposed(by: disposeBag)
    
    return output
  }
  
  func updateEmailValidationState(output: Output) {
    guard self.email.count > 0 else {
      output.emailValidationState.accept(.empty)
      return
    }
    guard self.email.isValidEmail() else {
      output.emailValidationState.accept(.wrongFormat)
      return
    }
    output.emailValidationState.accept(.correctFormat)
  }
  
  func updateNicknameValidationState(output: Output) {
    guard self.nickname.count > 0 else {
      output.nicknameValidationState.accept(.empty)
      return
    }
    guard self.nickname.isValidNickname() else {
      output.nicknameValidationState.accept(.wrongFormat)
      return
    }
    output.nicknameValidationState.accept(.correctFormat)
  }
  
}
