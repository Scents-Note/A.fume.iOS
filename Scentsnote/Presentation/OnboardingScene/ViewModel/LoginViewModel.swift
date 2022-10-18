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
    
    return output
  }
  
  init(coordinator: LoginCoordinator?) {
    self.coordinator = coordinator
  }
  
  func updateValidationState(output: Output) {
    guard isValidEmail(email: self.email), isValidPassword(password: self.password) else {
      output.doneButtonShouldEnable.accept(false)
      return
    }
    output.doneButtonShouldEnable.accept(true)
  }
  
  private func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: email)
  }
  
  private func isValidPassword(password: String) -> Bool {
    let passwordRegEx = "[A-Za-z0-9!_@$%^&+=]{4,}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return predicate.evaluate(with: password)
  }
}


