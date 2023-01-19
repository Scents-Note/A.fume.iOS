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
  
  // MARK: - Vars & Lets
  var viewModel: SignUpInformationViewModel!
  private var disposeBag = DisposeBag()

  // MARK: - UI
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
  
  private let nextButton = NextButton(frame: .zero, title: "다음")
  
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  // MARK: - Configure UI
  func configureUI() {
    self.view.backgroundColor = .white
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
    
    self.emailTextField.rx.text.orEmpty
      .bind(to: input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.emailCheckButton.rx.tap
      .bind(to: input.emailCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.nicknameTextField.rx.text.orEmpty
      .bind(to: input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.nicknameCheckButton.rx.tap
      .bind(to: input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.nextButton.rx.tap
      .bind(to: input.nextButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    self.bindEmailSection(output: output)
    self.bindNicknameSection(output: output)
    self.bindNextButton(output: output)
  }
  
  private func bindEmailSection(output: SignUpInformationViewModel.Output) {
    output.emailState
      .asDriver()
      .drive(onNext: { [weak self] state in
        self?.updateEmailSection(state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindNicknameSection(output: SignUpInformationViewModel.Output) {
    output.nicknameState
      .asDriver()
      .drive(onNext: { [weak self] state in
        self?.updateNicknameSection(state: state)
      })
      .disposed(by: self.disposeBag)
    
    output.hideNicknameSection
      .asDriver()
      .drive(onNext: { [weak self] isHidden in
        self?.updateNicknameSection(isHidden: isHidden)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindNextButton(output: SignUpInformationViewModel.Output) {
    output.canDone
      .asDriver()
      .drive(onNext: { [weak self] state in
        self?.updateNextButton(enable: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - Update UI
  private func updateEmailSection(state: InputState) {
    self.emailSection.updateUI(state: state)
    self.emailWarningLabel.text = state.emailDescription
    self.emailCheckButton.isHidden = state != .correctFormat && state != .duplicate
  }
  
  private func updateNicknameSection(state: InputState) {
    self.nicknameSection.updateUI(state: state)
    self.nicknameWarningLabel.text = state.nicknameDescription
    self.nicknameCheckButton.isHidden = state != .correctFormat && state != .duplicate
  }
  
  private func updateNicknameSection(isHidden: Bool) {
    self.nicknameSection.isHidden = isHidden
  }
  
  private func updateNextButton(enable: Bool) {
    self.nextButton.isHidden = !enable
  }
  
}
