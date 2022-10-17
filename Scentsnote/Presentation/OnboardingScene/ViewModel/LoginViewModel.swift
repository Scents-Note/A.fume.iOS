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
  private var email: String = ""
  
  struct Input {
    let nicknameTextFieldDidEditEvent: Observable<String>
  }
  
  struct Output {
    var nicknameFieldText = BehaviorRelay<String?>(value: "")
  }

  func transform(from input: Input, disposeBag: DisposeBag) {
    input.nicknameTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] nickname in
//        self?.
//        self?.coordinator?.runLoginFlow()
      })
      .disposed(by: disposeBag)
  }
  
  init(coordinator: LoginCoordinator?) {
    self.coordinator = coordinator
  }
}
