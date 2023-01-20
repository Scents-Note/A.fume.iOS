//
//  EditInformationViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import RxSwift
import RxRelay

final class EditInformationViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let nicknameTextFieldDidEditEvent = PublishRelay<String>()
    let nicknameCheckButtonDidTapEvent = PublishRelay<Void>()
    let manButtonDidTapEvent = PublishRelay<Void>()
    let womanButtonDidTapEvent = PublishRelay<Void>()
    let birthButtonDidTapEvent = PublishRelay<Void>()
    let doneButtonDidTapEvent = PublishRelay<Void>()
    let withdrawalButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct PopupInput {
    let birthDidEditEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let nickname = BehaviorRelay<String>(value: "")
    let nicknameState = BehaviorRelay<InputState>(value: .empty)
    let gender = BehaviorRelay<String>(value: "")
    let birth = BehaviorRelay<Int>(value: 1990)
    let canDone = BehaviorRelay<Bool>(value: false)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: EditInformationCoordinator?
  private let fetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase
  private let checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase
  private let updateUserInformationUseCase: UpdateUserInformationUseCase
  private let saveEditUserInfoUseCase: SaveEditUserInfoUseCase
  private let disposeBag = DisposeBag()
  var oldUserInfo = EditUserInfo.default
  var newUserInfo = EditUserInfo.default
  let input = Input()
  let popupInput = PopupInput()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: EditInformationCoordinator,
       fetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase,
       checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase,
       updateUserInformationUseCase: UpdateUserInformationUseCase,
       saveUserInfoUseCase: SaveEditUserInfoUseCase) {
    self.coordinator = coordinator
    self.fetchUserInfoForEditUseCase = fetchUserInfoForEditUseCase
    self.checkDuplicateNicknameUseCase = checkDuplicateNicknameUseCase
    self.updateUserInformationUseCase = updateUserInformationUseCase
    self.saveEditUserInfoUseCase = saveUserInfoUseCase
    
    self.transform(input: self.input, popupInput: self.popupInput, output: self.output)
  }
  
  
  // MARK: - Binding
  func transform(input: Input, popupInput: PopupInput, output: Output) {
    let nickname = PublishRelay<String>()
    let nicknameState = PublishRelay<InputState>()
    let gender = PublishRelay<String>()
    let birth = PublishRelay<Int>()
    let canDone = PublishRelay<Bool>()
    
    self.bindInput(input: input,
                   nickname: nickname,
                   nicknameState: nicknameState,
                   gender: gender,
                   canDone: canDone)
    
    self.bindPopupInput(input: popupInput,
                        birth: birth)
    
    self.bindOutput(output: output,
                    nickname: nickname,
                    nicknameState: nicknameState,
                    gender: gender,
                    birth: birth,
                    canDone: canDone)
    
    self.fetchDatas(nickname: nickname,
                    nicknameState: nicknameState,
                    gender: gender,
                    birth: birth)
  }
  
  private func bindInput(input: Input,
                         nickname: PublishRelay<String>,
                         nicknameState: PublishRelay<InputState>,
                         gender: PublishRelay<String>,
                         canDone: PublishRelay<Bool>) {
    
    input.nicknameTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.newUserInfo.nickname = text
        self?.updateNicknameState(nickname: text, nicknameState: nicknameState)
      })
      .disposed(by: self.disposeBag)
    
    input.nicknameCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkDuplicateNickname(nickname: self?.newUserInfo.nickname, nicknameState: nicknameState)
      })
      .disposed(by: self.disposeBag)
    
    input.manButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.newUserInfo.gender = "MAN"
        gender.accept("MAN")
      })
      .disposed(by: self.disposeBag)
    
    input.womanButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.newUserInfo.gender = "WOMAN"
        gender.accept("WOMAN")
      })
      .disposed(by: self.disposeBag)
    
    input.birthButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showBirthPopupViewController(with: self?.newUserInfo.birth ?? 2023)
      })
      .disposed(by: self.disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.updateUserInfo(userInfo: self?.newUserInfo)
      })
      .disposed(by: self.disposeBag)
    
    input.withdrawalButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showWebViewController(with: WebURL.withdrawal)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindPopupInput(input: PopupInput,
                              birth: PublishRelay<Int>) {
    input.birthDidEditEvent
      .subscribe(onNext: { [weak self] year in
        self?.newUserInfo.birth = year
        birth.accept(year)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindOutput(output: Output,
                          nickname: PublishRelay<String>,
                          nicknameState: PublishRelay<InputState>,
                          gender: PublishRelay<String>,
                          birth: PublishRelay<Int>,
                          canDone: PublishRelay<Bool>) {
    nickname
      .bind(to: output.nickname)
      .disposed(by: self.disposeBag)
    
    nicknameState
      .bind(to: output.nicknameState)
      .disposed(by: self.disposeBag)
    
    gender
      .bind(to: output.gender)
      .disposed(by: self.disposeBag)
    
    birth
      .bind(to: output.birth)
      .disposed(by: self.disposeBag)
    
    Observable.combineLatest(nicknameState, gender, birth)
      .subscribe(onNext: { [weak self] nicknameState, gender, birth in
        Log(gender)
        guard let new = self?.newUserInfo, let old = self?.oldUserInfo else { return }
        if new == old {
          output.canDone.accept(false)
          return
        }
        if new.nickname != old.nickname && nicknameState != .success {
          output.canDone.accept(false)
          return
        }
        output.canDone.accept(true)
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchDatas(nickname: PublishRelay<String>,
                          nicknameState: PublishRelay<InputState>,
                          gender: PublishRelay<String>,
                          birth: PublishRelay<Int>) {
    
    self.fetchUserInfoForEditUseCase.execute()
      .subscribe(onNext: { [weak self] userInfo in
        self?.oldUserInfo = userInfo
        self?.newUserInfo = userInfo
        nickname.accept(userInfo.nickname)
        nicknameState.accept(.empty)
        gender.accept(userInfo.gender)
        birth.accept(userInfo.birth)
      })
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - Update
  private func updateNicknameState(nickname: String, nicknameState: PublishRelay<InputState>) {
    guard nickname.count > 0 && nickname != self.oldUserInfo.nickname else {
      nicknameState.accept(.empty)
      return
    }
    guard nickname.isValidNickname() else {
      nicknameState.accept(.wrongFormat)
      return
    }
    nicknameState.accept(.correctFormat)
  }
  
  private func checkDuplicateNickname(nickname: String?, nicknameState: PublishRelay<InputState>) {
    guard let nickname = nickname else { return }
    self.checkDuplicateNicknameUseCase.execute(nickname: nickname)
      .subscribe { _ in
        nicknameState.accept(.success)
      } onError: { error in
        Log(error)
        nicknameState.accept(.duplicate)
      }
      .disposed(by: disposeBag)
  }
  
  private func updateUserInfo(userInfo: EditUserInfo?) {
    guard let userInfo = userInfo else { return }
    self.updateUserInformationUseCase.execute(userInfo: userInfo)
      .subscribe(onNext: { [weak self] result in
        self?.saveEditUserInfoUseCase.execute(userInfo: result)
        self?.coordinator?.finishFlow?()
      })
      .disposed(by: disposeBag)
  }
}

extension EditInformationViewModel: BirthPopupDismissDelegate {
  func birthPopupDismiss(with birth: Int) {
    self.updateBirth(birth: birth)
  }
  
  func updateBirth(birth: Int) {
    self.popupInput.birthDidEditEvent.accept(birth)
  }
}
