//
//  SignUpGenderViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class SignUpGenderViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let manButtonDidTapEvent = PublishRelay<Void>()
    let womanButtonDidTapEvent = PublishRelay<Void>()
    let nextButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    var genderState = BehaviorRelay<GenderState>(value: .none)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SignUpCoordinator?
  private var signUpInfo: SignUpInfo
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var genderDescription = ""
  
  init(coordinator: SignUpCoordinator?, signUpInfo: SignUpInfo) {
    self.coordinator = coordinator
    self.signUpInfo = signUpInfo
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Transform
  func transform(input: Input, output: Output) {
    let genderState = PublishRelay<GenderState>()
    
    self.bindInput(input: input, genderState: genderState)
    self.bindOutput(output: output, genderState: genderState)
  }
  
  func bindInput(input: Input, genderState: PublishRelay<GenderState>) {
    input.manButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        genderState.accept(.man)
        self?.genderDescription = GenderState.man.description
      })
      .disposed(by: disposeBag)
    
    input.womanButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        genderState.accept(.woman)
        self?.genderDescription = GenderState.woman.description
      })
      .disposed(by: disposeBag)
    
    input.nextButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.signUpInfo.gender = self?.genderDescription
        self?.coordinator?.showSignUpBirthViewController(with: self?.signUpInfo)
      })
      .disposed(by: disposeBag)
  }
  
  func bindOutput(output: Output, genderState: PublishRelay<GenderState>) {
    genderState
      .bind(to: output.genderState)
      .disposed(by: self.disposeBag)
  }
  
}
