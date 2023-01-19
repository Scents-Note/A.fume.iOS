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
  
  // MARK: - Vars & Lets
  var viewModel: SignUpPasswordViewModel!
  private var disposeBag = DisposeBag()

  // MARK: - UI
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

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  // MARK: - Configure UI
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
    
    self.view.addSubview(self.nextButton)
    self.nextButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.passwordTextField.rx.text.orEmpty
      .bind(to: input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.passwordCheckTextField.rx.text.orEmpty
      .bind(to: input.passwordCheckTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.nextButton.rx.tap
      .bind(to: input.nextButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    self.bindPasswordSection(output: output)
    self.bindPasswordCheckSection(output: output)
    self.bindNextButton(output: output)
  }
  
  private func bindPasswordSection(output: SignUpPasswordViewModel.Output) {
    output.passwordState
      .asDriver()
      .drive(onNext: { [weak self] state in
        self?.updatePasswordSection(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindPasswordCheckSection(output: SignUpPasswordViewModel.Output) {
    output.hidePasswordCheckSection
      .asDriver()
      .drive(onNext: { [weak self] isHidden in
        self?.passwordCheckSection.isHidden = isHidden
      })
      .disposed(by: self.disposeBag)
    
    output.passwordCheckState
      .asDriver()
      .drive(onNext: { [weak self] state in
        self?.updatePasswordCheckSection(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindNextButton(output: SignUpPasswordViewModel.Output) {
    output.canDone
      .asDriver()
      .drive(onNext: { [weak self] canDone in
        self?.updateNextButton(canDone: canDone)
      })
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - Update UI
  private func updatePasswordSection(state: InputState) {
    self.passwordSection.updateUI(state: state)
    self.passwordWarningLabel.text = state.passwordDescription
  }
  
  private func updatePasswordCheckSection(state: InputState) {
    self.passwordCheckSection.updateUI(state: state)
    self.passwordCheckWarningLabel.text = state.passwordCheckDescription
  }
  
  private func updateNextButton(canDone: Bool) {
    self.nextButton.isHidden = !canDone
  }
}
