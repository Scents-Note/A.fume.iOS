//
//  SignUpViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class SignUpBirthViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let birthButtonDidTapEvent = PublishRelay<Void>()
    let doneButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct PopupInput {
    let birthDidPickedEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let birth = BehaviorRelay<Int>(value: 1990)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SignUpCoordinator?
  private let signUpUseCase: SignUpUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  private var signUpInfo: SignUpInfo
  private let disposeBag = DisposeBag()
  
  let input = Input()
  let popupInput = PopupInput()
  let output = Output()
  /// Popup Callback
  var birth = 1990
  
  init(coordinator: SignUpCoordinator?,
       signUpUseCase: SignUpUseCase,
       saveLoginInfoUseCase: SaveLoginInfoUseCase,
       signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.signUpUseCase = signUpUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
    self.signUpInfo = signUpInfo
    
    self.transform(input: self.input, popupInput: self.popupInput, output: self.output)
  }
  
  // MARK: - Transform
  private func transform(input: Input, popupInput: PopupInput, output: Output) {
    let birth = PublishRelay<Int>()
    
    self.bindInput(input: input, popupInput: popupInput, birth: birth)
    self.bindOutput(output: output, birth: birth)
    
    
  }
  
  private func bindInput(input: Input, popupInput: PopupInput, birth: PublishRelay<Int>) {
    input.birthButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showBirthPopupViewController(with: self?.birth)
      })
      .disposed(by: self.disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.signUp(signUpInfo: self?.signUpInfo, birth: self?.birth)
        
      })
      .disposed(by: self.disposeBag)
    
    popupInput.birthDidPickedEvent
      .subscribe(onNext: { [weak self] _birth in
        self?.birth = _birth
        birth.accept(_birth)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output, birth: PublishRelay<Int>) {
    birth
      .bind(to: output.birth)
      .disposed(by: self.disposeBag)
  }
  
  private func signUp(signUpInfo: SignUpInfo?, birth: Int?) {
    guard let signUpInfo = signUpInfo, let birth = birth else { return }
    
    var updated = signUpInfo
    updated.birth = birth
    self.signUpUseCase.execute(signUpInfo: updated)
      .subscribe { loginInfo in
        let modified = LoginInfo(userIdx: loginInfo.userIdx,
                                 nickname: signUpInfo.nickname,
                                 gender: signUpInfo.gender,
                                 birth: signUpInfo.birth,
                                 token: loginInfo.token,
                                 refreshToken: loginInfo.refreshToken)
        self.saveLoginInfoUseCase.execute(loginInfo: modified, email: signUpInfo.email!, password: signUpInfo.password!)
        self.coordinator?.finishFlow?()
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
  }
}

extension SignUpBirthViewModel: BirthPopupDismissDelegate {
  func birthPopupDismiss(with birth: Int) {
    self.popupInput.birthDidPickedEvent.accept(birth)
  }
}
