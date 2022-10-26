//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import RxSwift
import RxRelay

final class SignUpInformationViewModel {
  private weak var coordinator: SignUpCoordinator?
  private let userRepository: UserRepository

  var email = ""
  var nickname = ""
  
  struct Input {
    let emailTextFieldDidEditEvent: Observable<String>
    let emailCheckButtonDidTapEvent: Observable<Void>
    let nicknameTextFieldDidEditEvent: Observable<String>
    let nicknameCheckButtonDidTapEvent: Observable<Void>

//    let nextDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var nextButtonShouldEnable = BehaviorRelay<Bool>(value: false)
    var emailValidationState = BehaviorRelay<InputState>(value: .empty)
    var nicknameValidationState = BehaviorRelay<InputState>(value: .empty)
    var doneButtonShouldEnable = BehaviorRelay<Bool>(value: false)
  }
  
  init(coordinator: SignUpCoordinator?, userRepository: UserRepository) {
    self.coordinator = coordinator
    self.userRepository = userRepository
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    input.emailTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] string in
        self?.email = string
        self?.updateEmailValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.emailCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.userRepository.checkDuplicateEmail(email: self.email, completion: { result in
          result.success { validation in
            switch validation {
            case true:
              output.emailValidationState.accept(.success)
            case false:
              output.emailValidationState.accept(.duplicate)
            default:
              break
            }
          }.catch { error in
            print("User Log: error \(self.email)")
          }
        })
      })
      .disposed(by: disposeBag)
    
    input.nicknameTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] string in
        self?.nickname = string
        self?.updateNicknameValidationState(output: output)
      })
      .disposed(by: disposeBag)
    
    input.nicknameCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.userRepository.checkDuplicateNickname(nickname: self.nickname, completion: { result in
          result.success { validation in
            switch validation {
            case true:
              output.nicknameValidationState.accept(.success)
            case false:
              output.nicknameValidationState.accept(.duplicate)
            default:
              break
            }
          }.catch { error in
            print("User Log: error \(error)")
          }
        })
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
