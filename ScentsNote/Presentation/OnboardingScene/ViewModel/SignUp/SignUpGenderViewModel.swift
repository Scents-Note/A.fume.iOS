//
//  SignUpGenderViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class SignUpGenderViewModel {
  private weak var coordinator: SignUpCoordinator?
  private var signUpInfo: SignUpInfo
  
  struct Input {
    let manButtonDidTapEvent: Observable<Void>
    let womanButtonDidTapEvent: Observable<Void>
    let nextButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var selectedGenderState = BehaviorRelay<GenderState>(value: .none)
  }
  
  init(coordinator: SignUpCoordinator?, signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.signUpInfo = signUpInfo
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    input.manButtonDidTapEvent
      .subscribe(onNext: {
        output.selectedGenderState.accept(.man)
      })
      .disposed(by: disposeBag)
    
    input.womanButtonDidTapEvent
      .subscribe(onNext: {
        output.selectedGenderState.accept(.woman)
      })
      .disposed(by: disposeBag)
    
    input.nextButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.signUpInfo.gender = output.selectedGenderState.value.description
        self.coordinator?.showSignUpBirthViewController(with: self.signUpInfo)
      })
      .disposed(by: disposeBag)
    
    return output
  }
}
