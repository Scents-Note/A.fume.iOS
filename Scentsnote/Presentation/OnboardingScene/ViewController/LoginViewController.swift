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
  }
  
  private lazy var emailSection = self.createInputSection(text: "이메일 주소를 입력해주세요.", textField: emailTextField)
  private lazy var passwordSection = self.createInputSection(text: "비밀번호를 입력해주세요.", textField: passwordTextField)
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = .systemBackground
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    self.navigationItem.titleView = self.navigationController?.setNavigationTitle(title: "로그인")
//    self.emailTextField.becomeFirstResponder()
  }
  
}

extension LoginViewController {
  private func configureUI() {
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
  }
  
  private func bindViewModel() {
    let input = LoginViewModel.Input(nicknameTextFieldDidEditEvent: self.emailTextField.rx.text.orEmpty.asObservable())
    self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
  }
  
  func createInputSection(text: String, textField: UITextField) -> UIStackView {
    let titleLabel = UILabel().then {
      $0.text = text
      $0.font = .notoSans(type: .regular)
      $0.textColor = .darkGray7d
    }
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.spacing = 10

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(textField)
    return stackView
  }
}

