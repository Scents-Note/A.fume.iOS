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
    let nicknameTextFieldDidEditEvent: Observable<String>
    let nicknameCheckButtonDidTapEvent: Observable<Void>
    let manButtonDidTapEvent: Observable<Void>
    let womanButtonDidTapEvent: Observable<Void>
    let birthButtonDidTapEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
    let withdrawalButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let nickname = BehaviorRelay<String>(value: "")
    let nicknameState = BehaviorRelay<InputState>(value: .empty)
    let gender = BehaviorRelay<String>(value: "")
    let birth = BehaviorRelay<Int>(value: 1990)
    let canDone = BehaviorRelay<Bool>(value: false)
  }
  
  struct PopupInput {
    let birthDidEditEvent = PublishRelay<Int>()
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: EditInformationCoordinator?
  private let fetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase
  private let checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase
  private let updateUserInformationUseCase: UpdateUserInformationUseCase
  private let saveUserInfoUseCase: SaveEditUserInfoUseCase
  
  private let popupInput = PopupInput()
  private var oldUserInfo = EditUserInfo.default
  
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
    self.saveUserInfoUseCase = saveUserInfoUseCase
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let nicknameState = BehaviorRelay<InputState>(value: .empty)
    let canDone = PublishRelay<Bool>()
    let nickname = BehaviorRelay<String>(value: "")
    let gender = BehaviorRelay<String>(value: "")
    let birth = BehaviorRelay<Int>(value: 1990)
    
    self.bindInput(input: input,
                   nickname: nickname,
                   nicknameState: nicknameState,
                   gender: gender,
                   birth: birth,
                   canDone: canDone,
                   disposeBag: disposeBag)
    
    self.bindPopupInput(input: self.popupInput,
                        birth: birth,
                        disposeBag: disposeBag)
    
    self.bindOutput(output: output,
                    nickname: nickname,
                    nicknameState: nicknameState,
                    gender: gender,
                    birth: birth,
                    canDone: canDone,
                    disposeBag: disposeBag)
    
    self.fetchDatas(nickname: nickname,
                    gender: gender,
                    birth: birth,
                    disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input,
                         nickname: BehaviorRelay<String>,
                         nicknameState: BehaviorRelay<InputState>,
                         gender: BehaviorRelay<String>,
                         birth: BehaviorRelay<Int>,
                         canDone: PublishRelay<Bool>,
                         disposeBag: DisposeBag) {
    input.nicknameTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        nickname.accept(text)
        self?.updateNicknameState(nickname: text, nicknameState: nicknameState)
      })
      .disposed(by: disposeBag)
    
    input.nicknameCheckButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkDuplicateNickname(nickname: nickname, nicknameState: nicknameState, disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.manButtonDidTapEvent
      .subscribe(onNext: {
        gender.accept("MAN")
      })
      .disposed(by: disposeBag)
    
    input.womanButtonDidTapEvent
      .subscribe(onNext: {
        gender.accept("WOMAN")
      })
      .disposed(by: disposeBag)
    
    input.birthButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showBirthPopupViewController(with: birth.value)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.updateUserInfo(userInfo: EditUserInfo(nickname: nickname.value,
                                                    gender: gender.value,
                                                    birth: birth.value),
                             disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.withdrawalButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showWebViewController(with: WebURL.withdrawal)
      })
      .disposed(by: disposeBag)
    
  }
  
  private func bindPopupInput(input: PopupInput,
                              birth: BehaviorRelay<Int>,
                              disposeBag: DisposeBag) {
    input.birthDidEditEvent
      .bind(to: birth)
      .disposed(by: disposeBag)
    
  }
  
  private func bindOutput(output: Output,
                          nickname: BehaviorRelay<String>,
                          nicknameState: BehaviorRelay<InputState>,
                          gender: BehaviorRelay<String>,
                          birth: BehaviorRelay<Int>,
                          canDone: PublishRelay<Bool>,
                          disposeBag: DisposeBag) {
    nickname
      .take(2)
      .bind(to: output.nickname)
      .disposed(by: disposeBag)
    
    nicknameState
      .bind(to: output.nicknameState)
      .disposed(by: disposeBag)
    
    gender
      .bind(to: output.gender)
      .disposed(by: disposeBag)
    
    birth
      .bind(to: output.birth)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(nicknameState, nickname, gender, birth)
      .subscribe(onNext: { [weak self] nicknameState, nickname, gender, birth in
        if nickname == self?.oldUserInfo.nickname && gender == self?.oldUserInfo.gender && birth == self?.oldUserInfo.birth {
          output.canDone.accept(false)
          return
        }
        if nickname != self?.oldUserInfo.nickname && nicknameState != .success {
          output.canDone.accept(false)
          return
        }
        output.canDone.accept(true)
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchDatas(nickname: BehaviorRelay<String>,
                          gender: BehaviorRelay<String>,
                          birth: BehaviorRelay<Int>,
                          disposeBag: DisposeBag) {
    self.fetchUserInfoForEditUseCase.execute()
      .subscribe(onNext: { [weak self] userInfo in
        self?.setOldValue(userInfo: userInfo)
        nickname.accept(userInfo.nickname)
        gender.accept(userInfo.gender)
        birth.accept(userInfo.birth)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Action
  private func setOldValue(userInfo: EditUserInfo) {
    self.oldUserInfo = EditUserInfo(nickname: userInfo.nickname,
                                    gender: userInfo.gender,
                                    birth: userInfo.birth)
  }
  
  private func updateNicknameState(nickname: String, nicknameState: BehaviorRelay<InputState>) {
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
  
  private func checkDuplicateNickname(nickname: BehaviorRelay<String>, nicknameState: BehaviorRelay<InputState>, disposeBag: DisposeBag) {
    self.checkDuplicateNicknameUseCase.execute(nickname: nickname.value)
      .subscribe { _ in
        nicknameState.accept(.success)
      } onError: { error in
        Log(error)
        nicknameState.accept(.duplicate)
      }
      .disposed(by: disposeBag)
  }
  
  private func updateUserInfo(userInfo: EditUserInfo, disposeBag: DisposeBag) {
    self.updateUserInformationUseCase.execute(userInfo: userInfo)
      .subscribe(onNext: { [weak self] result in
        self?.saveUserInfoUseCase.execute(userInfo: result)
        self?.coordinator?.finishFlow?()
      })
      .disposed(by: disposeBag)
    
  }
  
  func updateBirth(birth: Int) {
    self.popupInput.birthDidEditEvent.accept(birth)
  }
}

extension EditInformationViewModel: BirthPopupDismissDelegate{
  func birthPopupDismiss(with birth: Int) {
    self.updateBirth(birth: birth)
  }
}
