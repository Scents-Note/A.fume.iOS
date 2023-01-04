//
//  EditInformationViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class EditInformationViewController: UIViewController {
  // MARK: - Vars & Lets
  var viewModel: EditInformationViewModel?
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let nicknameWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let birthTitleLabel = UILabel().then {
    $0.text = "출생연도를 선택해주세요."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 14)
  }
  
  private let birthButton = UIButton().then {
    $0.setTitle("1990", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .nanumMyeongjo(type: .extraBold, size: 22)
    $0.layer.cornerRadius = 2
    $0.backgroundColor = .pointBeige
  }
  
  private let withdrawalButton = UIButton().then {
    $0.semanticContentAttribute = .forceRightToLeft
    $0.setImage(.arrowRight, for: .normal)
    $0.setTitle("회원 탈퇴", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 14)
  }
  
  private let nicknameView = EditInformationNicknameView()
  private let genderView = EditInformationGenderView()
  private let doneButton = DoneButton(title: "수정 완료")
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    
    self.view.backgroundColor = .white
    self.view.addSubview(self.nicknameView)
    self.nicknameView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.greaterThanOrEqualTo(70)
    }
    
    self.view.addSubview(self.nicknameWarningLabel)
    self.nicknameWarningLabel.snp.makeConstraints {
      $0.top.equalTo(self.nicknameView.snp.bottom).offset(8)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.view.addSubview(self.genderView)
    self.genderView.snp.makeConstraints {
      $0.top.equalTo(self.nicknameView.snp.bottom).offset(50)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.greaterThanOrEqualTo(200)
    }
    
    self.view.addSubview(self.birthTitleLabel)
    self.birthTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.genderView.snp.bottom).offset(24)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.view.addSubview(self.birthButton)
    self.birthButton.snp.makeConstraints {
      $0.top.equalTo(self.birthTitleLabel.snp.bottom).offset(16)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(48)
    }
    
    self.view.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
    }
    
    self.view.addSubview(self.withdrawalButton)
    self.withdrawalButton.snp.makeConstraints {
      $0.bottom.equalTo(self.doneButton.snp.top).offset(-16)
      $0.right.equalToSuperview().offset(-16)
      $0.height.equalTo(32)
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "내 정보 수정")
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = EditInformationViewModel.Input(
      nicknameTextFieldDidEditEvent: self.nicknameView.editTextField(),
      nicknameCheckButtonDidTapEvent: self.nicknameView.clickDoubleCheck(),
      manButtonDidTapEvent: self.genderView.clickManButton(),
      womanButtonDidTapEvent: self.genderView.clickWomanButton(),
      birthButtonDidTapEvent: self.birthButton.rx.tap.asObservable(),
      doneButtonDidTapEvent: self.doneButton.rx.tap.asObservable(),
      withdrawalButtonDidTapEvent: self.withdrawalButton.rx.tap.asObservable()
    )
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
    self.bindNickname(output: output)
    self.bindGender(output: output)
    self.bindBirth(output: output)
    self.bindDoneButton(output: output)
  }
  
  private func bindNickname(output: EditInformationViewModel.Output?) {
    output?.nickname
      .subscribe(onNext: { [weak self] nickname in
        self?.updateNickname(nickname: nickname)
      })
      .disposed(by: self.disposeBag)
    
    output?.nicknameState
      .subscribe(onNext: { [weak self] state in
        self?.updateNicknameSection(state: state)
      })
      .disposed(by: self.disposeBag)

  }
  private func bindGender(output: EditInformationViewModel.Output?) {
    output?.gender
      .subscribe(onNext: { [weak self] gender in
        self?.updateGender(gender: gender)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindBirth(output: EditInformationViewModel.Output?) {
    output?.birth
      .subscribe(onNext: { [weak self] birth in
        self?.updateBirth(birth: birth)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindDoneButton(output: EditInformationViewModel.Output?) {
    output?.canDone
      .subscribe(onNext: { [weak self] canDone in
        self?.updateDoneButton(canDone: canDone)
      })
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - ACTion
  private func updateNickname(nickname: String) {
    self.nicknameView.updateNickname(nickname: nickname)
  }
  
  private func updateNicknameSection(state: InputState) {
    self.nicknameView.updateNicknameSection(state: state)
    self.nicknameWarningLabel.text = state.nicknameDescription
  }
  
  private func updateGender(gender: String) {
    self.genderView.updateGenderSection(gender: gender)
  }
  
  private func updateBirth(birth: Int) {
    self.birthButton.setTitle("\(birth)", for: .normal)
  }
  
  private func updateDoneButton(canDone: Bool) {
    self.doneButton.backgroundColor = canDone ? .blackText : .grayCd
    self.doneButton.isEnabled = canDone
  }
}

extension EditInformationViewController: BirthPopupDismissDelegate{
  func birthPopupDismiss(with birth: Int) {
    self.viewModel?.updateBirth(birth: birth)
  }
}
