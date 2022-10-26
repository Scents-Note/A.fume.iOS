//
//  SignUpViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class SignUpInformationViewController: UIViewController {
  
  var viewModel: SignUpInformationViewModel?
  private var disposeBag = DisposeBag()
  private var isNicknameSectionShown: Bool?

  private let container = UIView()
  
  private let emailTextField = InputField().then { $0.setPlaceholder(string: "scents@email.com") }
  private let emailWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  private let emailCheckButton = DoubleCheckButton()
  private lazy var emailSection = InputSection(title: "이메일 주소를 입력해주세요.", textField: self.emailTextField, button: self.emailCheckButton, warningLabel: emailWarningLabel)
  
  private let nicknameTextField = InputField().then { $0.setPlaceholder(string: "예) 어퓸덕후") }
  private let nicknameWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  private let nicknameCheckButton = DoubleCheckButton()
  private lazy var nicknameSection = InputSection(title: "사용하실 닉네임을 입력해주세요.", textField: self.nicknameTextField, button: self.nicknameCheckButton, warningLabel: nicknameWarningLabel)
  
  private let nextButton = DoneButton(frame: .zero, title: "다음")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
}

extension SignUpInformationViewController {
  func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.setBackButton()
    self.setNavigationTitle(title: "회원가입")
    
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20)
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
    
    self.container.addSubview(self.emailSection)
    self.emailSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalToSuperview().offset(32)
    }
    
    self.container.addSubview(self.nicknameSection)
    self.nicknameSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.emailSection.snp.bottom).offset(42)
    }
    self.nicknameSection.isHidden = true
    
    self.view.addSubview(self.nextButton)
    self.nextButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
      $0.bottom.equalToSuperview()
    }
  }
  
}

// MARK: - Input & OutPut
extension SignUpInformationViewController {
  private func bindViewModel() {
    let input = SignUpInformationViewModel.Input(
      emailTextFieldDidEditEvent: self.emailTextField.rx.text.orEmpty.asObservable(),
      emailCheckButtonDidTapEvent: self.emailCheckButton.rx.tap.asObservable(),
      nicknameTextFieldDidEditEvent: self.nicknameTextField.rx.text.orEmpty.asObservable(),
      nicknameCheckButtonDidTapEvent: self.nicknameCheckButton.rx.tap.asObservable(),
      nextButtonDidTapEvent: self.nextButton.rx.tap.asObservable()
    )
    
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindEmailSection(output: output)
    self.bindNicknameSection(output: output)
    self.bindNextButton(output: output)
    
  }
  
  private func bindEmailSection(output: SignUpInformationViewModel.Output?) {
    output?.emailValidationState
      .asDriver(onErrorJustReturn: .empty)
      .drive(onNext: { [weak self] state in
        self?.updateEmailSection(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindNicknameSection(output: SignUpInformationViewModel.Output?) {
    output?.nicknameValidationState
      .asDriver(onErrorJustReturn: .empty)
      .drive(onNext: { [weak self] state in
        self?.updateNicknameValidationButton(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindNextButton(output: SignUpInformationViewModel.Output?) {
    guard let output = output else { return }
    Observable.combineLatest(output.emailValidationState, output.nicknameValidationState)
      .subscribe(onNext: { [weak self] emailValidation, nicknameValidation in
        if emailValidation == .success, nicknameValidation == .success {
          self?.updateNextButton(enable: true)
        } else {
          self?.updateNextButton(enable: false)
        }
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Update UI
extension SignUpInformationViewController {
  private func updateEmailSection(state: InputState) {
    self.emailSection.updateUI(state: state)
    self.emailWarningLabel.text = state.emailDescription
    self.emailCheckButton.isHidden = !(state == .correctFormat)
    if self.isNicknameSectionShown != true, state == .success {
      self.nicknameSection.isHidden = false
      self.isNicknameSectionShown = true
    }
  }
  
  private func updateNicknameValidationButton(state: InputState) {
    self.nicknameSection.updateUI(state: state)
    self.nicknameWarningLabel.text = state.nicknameDescription
    self.nicknameCheckButton.isHidden = !(state == .correctFormat)
  }
  
  private func updateNextButton(enable: Bool) {
    self.nextButton.isHidden = !enable
  }
}
