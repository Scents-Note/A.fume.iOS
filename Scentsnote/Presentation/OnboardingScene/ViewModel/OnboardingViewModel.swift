//
//  SignViewModel.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation

import RxSwift
import RxRelay

final class OnboardingViewModel {
  weak var coordinator: OnboardingCoordinator?
  private let disposeBag = DisposeBag()
  
  init(coordinator: OnboardingCoordinator) {
    self.coordinator = coordinator
  }
  
  struct Input {
    let loginButtonDidTapEvent: Observable<Void>
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) {
    input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runLoginFlow()
      })
      .disposed(by: disposeBag)
  }
}
