//
//  SignViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation

import RxSwift
import RxRelay

final class OnboardingViewModel {
  
  // MARK: - Input
  struct Input {
    let loginButtonDidTapEvent = PublishRelay<Void>()
    let signUpButtonDidTapEvent = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: OnboardingCoordinator?
  private let disposeBag = DisposeBag()
  let input = Input()
  
  init(coordinator: OnboardingCoordinator) {
    self.coordinator = coordinator
    self.transform(input: self.input)
  }
  
  func transform(input: Input) {
    input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runLoginFlow() 
      })
      .disposed(by: self.disposeBag)
    
    input.signUpButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSignUpFlow()
      })
      .disposed(by: self.disposeBag)
  }
}
