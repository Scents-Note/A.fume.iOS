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
  
  private var disposeBag = DisposeBag()
  var viewModel: SignUpInformationViewModel?
  
  private let container = UIView()
  private let emailWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let nicknameWarningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let emailCheckButton = DoubleCheckButton()
  private let nicknameCheckButton = DoubleCheckButton()

  private let emailTextField = InputField().then { $0.setPlaceholder(string: "scents@email.com") }
  private let nicknameTextField = InputField().then { $0.setPlaceholder(string: "예) 어퓸덕후") }
  
  private let nextButton = UIButton().then {
    $0.setTitle("다음", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)
    $0.setImage(.btnNext, for: .normal)
    $0.contentHorizontalAlignment = .right
    $0.layer.backgroundColor = UIColor.blackText.cgColor
    $0.semanticContentAttribute = .forceRightToLeft
    $0.contentEdgeInsets = .init(top: 0, left: 10, bottom: 34, right: 20)
  }
  
  private lazy var emailSection = InputSection(title: "이메일 주소를 입력해주세요.", textField: self.emailTextField, button: self.emailCheckButton)
  private lazy var nicknameSection = InputSection(title: "사용하실 닉네임을 입력해주세요.", textField: self.nicknameTextField, button: self.nicknameCheckButton)
  
  private var isNicknameSectionShown: Bool?
  
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
      $0.top.equalToSuperview().offset(30)
    }
    
    self.container.addSubview(self.emailWarningLabel)
    self.emailWarningLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.emailSection.snp.bottom).offset(8)
    }
    
    self.container.addSubview(self.nicknameSection)
    self.nicknameSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.emailSection.snp.bottom).offset(42)
    }
    self.nicknameSection.isHidden = true
    
    self.container.addSubview(self.nicknameWarningLabel)
    self.nicknameWarningLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.nicknameSection.snp.bottom).offset(8)
    }

    self.view.addSubview(self.nextButton)
    self.nextButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
      $0.bottom.equalToSuperview()
    }
  }
  
}

extension SignUpInformationViewController {
  func bindViewModel() {
    let input = SignUpInformationViewModel.Input(
      emailTextFieldDidEditEvent: self.emailTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
      emailCheckButtonDidTapEvent: self.emailCheckButton.rx.tap.asObservable(),
      nicknameTextFieldDidEditEvent: self.nicknameTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
      nicknameCheckButtonDidTapEvent: self.nicknameCheckButton.rx.tap.asObservable()
    )
    
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindEmailSection(output: output)
    self.bindNicknameSection(output: output)
    self.bindNextButton(output: output)
    
  }
  
  func bindEmailSection(output: SignUpInformationViewModel.Output?) {
    output?.emailValidationState
      .asDriver(onErrorJustReturn: .empty)
      .drive(onNext: { [weak self] state in
        self?.updateEmailValidationButton(state: state)
        self?.emailSection.updateUI(state: state)
        self?.emailWarningLabel.text = state.emailDescription
        if self?.isNicknameSectionShown != true, state == .success {
          self?.nicknameSection.isHidden = false
          self?.isNicknameSectionShown = true
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  func bindNicknameSection(output: SignUpInformationViewModel.Output?) {
    output?.nicknameValidationState
      .asDriver(onErrorJustReturn: .empty)
      .drive(onNext: { [weak self] state in
        self?.updateNicknameValidationButton(state: state)
        self?.nicknameSection.updateUI(state: state)
        self?.nicknameWarningLabel.text = state.nicknameDescription
      })
      .disposed(by: self.disposeBag)
  }
  
  func bindNextButton(output: SignUpInformationViewModel.Output?) {
    guard let output = output else { return }
    Observable.combineLatest(output.emailValidationState, output.nicknameValidationState)
      .subscribe(onNext: { [weak self] emailValidation, nicknameValidation in
        if emailValidation == .success, nicknameValidation == .success {
          self?.isNextButtonEnable(enable: true)
        } else {
          self?.isNextButtonEnable(enable: false)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension SignUpInformationViewController {
  func updateEmailValidationButton(state: InputState) {
    self.emailCheckButton.isHidden = !(state == .correctFormat)
  }
  
  func updateNicknameValidationButton(state: InputState) {
    self.nicknameCheckButton.isHidden = !(state == .correctFormat)
  }
  
  func isNextButtonEnable(enable: Bool) {
    self.nextButton.isHidden = !enable
  }
}
