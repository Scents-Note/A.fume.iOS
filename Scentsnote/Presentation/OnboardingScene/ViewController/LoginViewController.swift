//
//  LoginViewController.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

import RxSwift
import SnapKit
import Then

class LoginViewController: ViewController {
  
  private var disposeBag = DisposeBag()
  var viewModel: LoginViewModel?
  
  // MARK: - View
  private let container = UIView()
  
  private let emailTextField = UnderLineTextField().then {
    $0.setPlaceholder(string: "scents@email.com")
  }
  
  private let passwordTextField = UnderLineTextField().then {
    $0.setPlaceholder(string: "최소 4자리 이상 입력해주세요.")
    $0.isSecureTextEntry = true
  }
  
  private let loginButton = UIButton().then {
    $0.setTitle("로그인 하기", for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.backgroundColor = UIColor.grayCd.cgColor
  }
  
  private let noAccountLabel = UILabel().then {
    $0.text = "혹시 계정이 없으신가요?"
    $0.font = .notoSans(type: .regular, size: 14)
    $0.textColor = .blackText
  }
  
  private let signUpButton = UIButton().then {
    $0.setTitle("회원가입하기", for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 14)
    $0.setTitleColor(.blackText, for: .normal)
  }
  
  private lazy var signUpStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.spacing = 12
    
    $0.addArrangedSubview(noAccountLabel)
    $0.addArrangedSubview(signUpButton)
  }
  
  private lazy var emailSection = InputSection(title: "이메일 주소를 입력해주세요.", textField: self.emailTextField)
  private lazy var passwordSection = InputSection(title: "비밀번호를 입력해주세요.", textField: self.passwordTextField)
  
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

extension LoginViewController {
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.setBackButton()
    self.setNavigationTitle(title: "로그인")

    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
      $0.top.bottom.equalToSuperview()
    }
    self.container.addSubview(self.emailSection)
    self.emailSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
    }
    
    self.container.addSubview(self.passwordSection)
    self.passwordSection.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.emailSection.snp.bottom).offset(42)
    }
    
    self.container.addSubview(self.loginButton)
    self.loginButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.passwordSection.snp.bottom).offset(31)
      $0.height.equalTo(52)
    }
    
    self.container.addSubview(self.signUpStackView)
    self.signUpStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.loginButton.snp.bottom).offset(22)
    }
    
    
  }
  
  private func bindViewModel() {
    let input = LoginViewModel.Input(
      emailTextFieldDidEditEvent: self.emailTextField.rx.text.orEmpty.asObservable(),
      passwordTextFieldDidEditEvent: self.passwordTextField.rx.text.orEmpty.asObservable(),
      signupButtonDidTapEvent: self.signUpButton.rx.tap.asObservable()
    )
      
    let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
    self.bindLoginButton(output: output)
  }
}

extension LoginViewController {
  func bindLoginButton(output: LoginViewModel.Output?) {
    output?.doneButtonShouldEnable
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] isValid in
        self?.loginButton.isEnabled = isValid
        self?.loginButton.backgroundColor = isValid ? .blackText : .grayCd
      })
      .disposed(by: self.disposeBag)
  }
}
