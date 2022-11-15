//
//  MyPageVIewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay

final class MyPageViewModel {
  let disposeBag = DisposeBag()
  private weak var coordinator: MyPageCoordinator?

  
  struct Input {
    let loginButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var selectedTab = BehaviorRelay<Int>(value: 0)
  }
  
  init(coordinator: MyPageCoordinator) {
    self.coordinator = coordinator
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.onOnboardingFlow?()
      })
      .disposed(by: self.disposeBag)
    
    return output
  }
}
