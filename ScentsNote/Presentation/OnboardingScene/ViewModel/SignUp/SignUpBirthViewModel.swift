//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class SignUpBirthViewModel {
  private weak var coordinator: SignUpCoordinator?
  private let userRepository: UserRepository
  private var signUpInfo: SignUpInfo
  var birth = BehaviorRelay<String>(value: "1990")


  struct Input {
    let birthButtonDidTapEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
  }

  
  init(coordinator: SignUpCoordinator?, userRepository: UserRepository, signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.userRepository = userRepository
    self.signUpInfo = signUpInfo
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) {
    
    input.birthButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showBirthPopupViewController(with: self?.birth.value ?? "1990")
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.signUpInfo.birth = Int(self.birth.value)
        print("User Log: signUp \(self.signUpInfo)")
        self.userRepository.signUp(signUpInfo: self.signUpInfo, completion: { result in
          result.success { loginInfo in
            print(loginInfo)
          }.catch { error in
            print("User Log: error \(error)")
          }
        })
      })
      .disposed(by: disposeBag)

  }
}

