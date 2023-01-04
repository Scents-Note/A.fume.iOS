//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class SignUpBirthViewModel {
  
  struct Input {
    let birthButtonDidTapEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  private weak var coordinator: SignUpCoordinator?
  private let signUpUseCase: SignUpUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  private var signUpInfo: SignUpInfo
  
  /// Popup Callback
  var birth = BehaviorRelay<Int>(value: 1990)
  
  init(coordinator: SignUpCoordinator?,
       signUpUseCase: SignUpUseCase,
       saveLoginInfoUseCase: SaveLoginInfoUseCase,
       signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.signUpUseCase = signUpUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
    self.signUpInfo = signUpInfo
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) {
    
    input.birthButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showBirthPopupViewController(with: self?.birth.value ?? 1990)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.signUpInfo.birth = self.birth.value
        self.signUpUseCase.execute(signUpInfo: self.signUpInfo)
          .subscribe { loginInfo in
            let modified = LoginInfo(userIdx: loginInfo.userIdx,
                                     nickname: self.signUpInfo.nickname,
                                     gender: self.signUpInfo.gender,
                                     birth: self.signUpInfo.birth,
                                     token: loginInfo.token,
                                     refreshToken: loginInfo.refreshToken)
            self.saveLoginInfoUseCase.execute(loginInfo: modified, email: self.signUpInfo.email!, password: self.signUpInfo.password!)
            self.coordinator?.finishFlow?()
          } onError: { error in
            Log(error)
          }
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
    
  }
}

