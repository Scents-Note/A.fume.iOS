//
//  CommonInputSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

enum inputType {
  case passwordCurrent
  case password
  case passwordCheck
}

class CommonInputSection: UIView {
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 14)
    $0.textColor = .darkGray7d
  }
  
  private let warningLabel = UILabel().then {
    $0.textColor = .brick
    $0.font = .notoSans(type: .regular, size: 12)
    $0.numberOfLines = 0
  }
  
  private let checkImage = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = .check
  }
  
  private let textField = InputField().then { $0.setPlaceholder(string: "scents@email.com") }
  private let checkButton = DoubleCheckButton()
  private let underLineView = UIView().then { $0.backgroundColor = .blackText }

  // MARK: - Life Cycle
  required init(title: String, placeholder: String){
    super.init(frame: .zero)
    self.configureUI(title: title, placeholder: placeholder)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure
  private func configureUI(title: String, placeholder: String) {
    self.titleLabel.text = title
    self.textField.setPlaceholder(string: placeholder)
    
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }
    
    self.addSubview(self.checkImage)
    self.addSubview(self.textField)
    self.checkImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    self.checkImage.snp.makeConstraints {
      $0.centerY.equalTo(self.textField)
      $0.right.equalToSuperview()
    }
    self.checkImage.isHidden = true
    
    self.textField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.left.equalToSuperview()
      $0.right.equalTo(self.checkImage.snp.right).offset(-8)
    }
    
    self.addSubview(self.underLineView)
    self.underLineView.snp.makeConstraints {
      $0.top.equalTo(self.textField.snp.bottom).offset(11)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func setSecurityType() {
    self.textField.isSecureTextEntry = true
  }
  
  func configureButton(title: String) {
    self.checkButton.setTitle(title, for: .normal)
    
    self.addSubview(self.checkButton)
    self.checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    self.checkButton.snp.makeConstraints {
      $0.centerY.equalTo(self.textField)
      $0.right.equalToSuperview()
    }
  }
  
  func configureWarningLabel() {
    self.addSubview(self.warningLabel)
    
    self.warningLabel.snp.makeConstraints {
      $0.top.equalTo(self.underLineView.snp.bottom).offset(8)
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview()
    }
    
    self.underLineView.snp.makeConstraints {
      $0.bottom.equalTo(self.warningLabel.snp.top).offset(-8)
    }
  }
  
  func editText() -> Observable<String> {
    self.textField.rx.text.orEmpty.asObservable()
  }
  
  func clickCheckButton() -> Observable<Void> {
    self.checkButton.rx.tap.asObservable()
  }
  
  func updateUI(type: inputType, state: InputState) {
    switch type {
    case .passwordCurrent:
      self.checkButton.isHidden = state != .correctFormat
      fallthrough
    case .password:
      self.checkImage.isHidden = state != .success
      self.warningLabel.text = state.passwordDescription
      self.textField.textColor = state == .duplicate || state == .wrongFormat || state == .notCorrect ? .brick : .blackText
    case .passwordCheck:
      self.checkImage.isHidden = state != .success
      self.warningLabel.text = state.passwordCheckDescription
      self.textField.textColor = state == .duplicate || state == .wrongFormat ? .brick : .blackText
    }
  }
}
