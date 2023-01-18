//
//  LoginViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class LoginViewController: UIViewController {
  
  private var disposeBag = DisposeBag()
  var viewModel: LoginViewModel!
  
  // MARK: - View
  private let container = UIView()
  
  private let emailTextField = InputField().then { $0.setPlaceholder(string: "scents@email.com") }
  private let passwordTextField = InputField().then {
    $0.setPlaceholder(string: "최소 4자리 이상 입력해주세요.")
    $0.isSecureTextEntry = true
  }
  
  private let loginButton = UIButton().then {
    $0.setTitle("로그인 하기", for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.backgroundColor = UIColor.grayCd.cgColor
  }
  
  private let notCorrectLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .systemFont(ofSize: 12, weight: .regular)
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
}

extension LoginViewController {
  
  private func configureUI() {
    self.view.backgroundColor = .white
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
    
    self.container.addSubview(self.notCorrectLabel)
    self.notCorrectLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.passwordSection.snp.bottom).offset(11)
    }
    
    self.container.addSubview(self.loginButton)
    self.loginButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.notCorrectLabel.snp.bottom).offset(32)
      $0.height.equalTo(52)
    }
    
    self.container.addSubview(self.signUpStackView)
    self.signUpStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.loginButton.snp.bottom).offset(22)
    }
  }
  
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.emailTextField.rx.text.orEmpty.asObservable()
      .bind(to: input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.passwordTextField.rx.text.orEmpty.asObservable()
      .bind(to: input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.loginButton.rx.tap.asObservable()
      .bind(to: input.loginButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.signUpButton.rx.tap.asObservable()
      .bind(to: input.signupButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    self.bindLoginButton(output: output)
  }
}

extension LoginViewController {
  func bindLoginButton(output: LoginViewModel.Output) {
    output.canDone
      .asDriver()
      .drive(onNext: { [weak self] isValid in
        self?.loginButton.isEnabled = isValid
        self?.loginButton.backgroundColor = isValid ? .blackText : .grayCd
      })
      .disposed(by: self.disposeBag)
    
    output.notCorrect
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.notCorrectLabel.text = "입력된 아이디 또는 비밀번호가 올바르지 않습니다."
      })
      .disposed(by: self.disposeBag)
  }
}
