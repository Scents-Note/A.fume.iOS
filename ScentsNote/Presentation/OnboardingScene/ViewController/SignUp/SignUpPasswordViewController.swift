//
//  SignUpPasswordViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class SignUpPasswordViewController: UIViewController {
  
  var viewModel: SignUpPasswordViewModel?
  private var disposeBag = DisposeBag()
  private var isPasswordCheckSectionShown: Bool?

  private let container = UIView()
  
  private let passwordTextField = InputField().then {
    $0.setPlaceholder(string: "최소 4자리 이상 입력해주세요.")
    $0.isSecureTextEntry = true
  }
  private let passwordWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  private lazy var passwordSection = InputSection(title: "비밀번호를 입력해주세요.", textField: self.passwordTextField, warningLabel: passwordWarningLabel)
  
  private let passwordCheckTextField = InputField().then {
    $0.setPlaceholder(string: "틀리지 않도록 주의해주세요.")
    $0.isSecureTextEntry = true
  }
  private let passwordCheckWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  private lazy var passwordCheckSection = InputSection(title: "비밀번호를 재확인할게요.", textField: self.passwordCheckTextField, warningLabel: passwordCheckWarningLabel)

  private let nextButton = NextButton(frame: .zero, title: "다음")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
}

extension SignUpPasswordViewController {
  private func configureUI() {
    self.view.backgroundColor = .white
    self.setBackButton()
    self.setNavigationTitle(title: "회원가입")
    
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(20)
    }
    
    self.container.addSubview(self.passwordSection)
    self.passwordSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalToSuperview().offset(30)
    }
    
    self.container.addSubview(self.passwordCheckSection)
    self.passwordCheckSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.passwordSection.snp.bottom).offset(42)
    }
    self.passwordCheckSection.isHidden = true
    
    self.view.addSubview(self.nextButton)
    self.nextButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
      $0.bottom.equalToSuperview()
    }
  }
  
 
}

// MARK: - Input & OutPut
extension SignUpPasswordViewController {
  private func bindViewModel() {
    let input = SignUpPasswordViewModel.Input(
      passwordTextFieldDidEditEvent: self.passwordTextField.rx.text.orEmpty.asObservable(),
      passwordCheckTextFieldDidEditEvent: self.passwordCheckTextField.rx.text.orEmpty.asObservable(),
      nextButtonDidTapEvent: self.nextButton.rx.tap.asObservable()
    )
    
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindPasswordSection(output: output)
    self.bindPasswordCheckSection(output: output)
    self.bindNextButton(output: output)
  }
  
  private func bindPasswordSection(output: SignUpPasswordViewModel.Output?) {
    output?.passwordValidationState
      .asDriver(onErrorJustReturn: .empty)
      .drive(onNext: { [weak self] state in
        self?.updatePasswordSection(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindPasswordCheckSection(output: SignUpPasswordViewModel.Output?) {
    output?.passwordCheckValidationState
      .asDriver(onErrorJustReturn: .empty)
      .drive(onNext: { [weak self] state in
        self?.updatePasswordCheckSection(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindNextButton(output: SignUpPasswordViewModel.Output?) {
    guard let output = output else { return }
    Observable.combineLatest(output.passwordValidationState, output.passwordCheckValidationState)
      .subscribe(onNext: { [weak self] passwordValidation, passwordCheckValidation in
        if passwordValidation == .success, passwordCheckValidation == .success {
          self?.updateNextButton(enable: true)
        } else {
          self?.updateNextButton(enable: false)
        }
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Update UI
extension SignUpPasswordViewController {
  private func updatePasswordSection(state: InputState) {
    self.passwordSection.updateUI(state: state)
    self.passwordWarningLabel.text = state.passwordDescription
    if self.isPasswordCheckSectionShown != true, state == .success {
      self.passwordCheckSection.isHidden = false
      self.isPasswordCheckSectionShown = true
    }
  }
  
  private func updatePasswordCheckSection(state: InputState) {
    self.passwordCheckSection.updateUI(state: state)
    self.passwordCheckWarningLabel.text = state.passwordCheckDescription
  }
  
  private func updateNextButton(enable: Bool) {
    self.nextButton.isHidden = !enable
  }
}
