//
//  SignUpViewController.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class SignUpViewController: ViewController {
  
  private var disposeBag = DisposeBag()
  var viewModel: SignUpViewModel?
  
  private let container = UIView()
  private let warningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let emailTextField = UnderLineTextField().then { $0.setPlaceholder(string: "scents@email.com") }
  private let nicknameTextField = UnderLineTextField().then { $0.setPlaceholder(string: "예) 어퓸덕후") }
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
  
  private lazy var emailSection = InputSection(title: "이메일 주소를 입력해주세요.", textField: self.emailTextField)
  private lazy var nicknameSection = InputSection(title: "사용하실 닉네임을 입력해주세요.", textField: self.nicknameTextField)
  
  
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

extension SignUpViewController {
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
    
    self.container.addSubview(self.warningLabel)
    self.warningLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.emailSection.snp.bottom).offset(8)
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
}

extension SignUpViewController {
  func bindViewModel() {
    let input = SignUpViewModel.Input(
      emailTextFieldDidEditEvent: self.emailTextField.rx.text.orEmpty.asObservable(),
      nicknameTextFieldDidEditEvent: self.nicknameTextField.rx.text.orEmpty.asObservable())
//      nextDidTapEvent: self.nicknameTextField.rx.text.orEmpty.asObservable()
  }
}
