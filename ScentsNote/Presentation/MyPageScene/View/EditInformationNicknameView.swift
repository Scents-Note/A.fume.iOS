//
//  EditInformationNicknameView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class EditInformationNicknameView: UIView {
  
  // MARK: - UI
  private let nicknameTitleLabel = UILabel().then {
    $0.text = "사용하실 닉네임을 입력해주세요."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 14)
  }
  
  private let checkImage = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = .check
  }
  
  private let nicknameDividerView = UIView().then { $0.backgroundColor = .blackText }
  let nickTextField = InputField()
  let nicknameCheckButton = DoubleCheckButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
//  required init(textField: UITextField, button: UIButton? = nil){
//    super.init(frame: .zero)
//    self.configureUI()
//  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.blackText.cgColor
    
    self.addSubview(self.nicknameTitleLabel)
    self.nicknameTitleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview().offset(16)
    }
    
    self.addSubview(self.nicknameDividerView)
    self.nicknameDividerView.snp.makeConstraints {
      $0.top.equalTo(self.nicknameTitleLabel.snp.bottom).offset(16)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.addSubview(self.nicknameCheckButton)
    self.nicknameCheckButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    self.nicknameCheckButton.snp.makeConstraints {
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.addSubview(self.nickTextField)
    self.nickTextField.snp.makeConstraints {
      $0.top.equalTo(self.nicknameDividerView.snp.bottom).offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.left.equalToSuperview().offset(16)
      $0.right.equalTo(self.nicknameCheckButton.snp.left).offset(-8)
    }
    
    self.nicknameCheckButton.snp.makeConstraints {
      $0.centerY.equalTo(self.nickTextField)
    }
    
    self.addSubview(self.checkImage)
    self.checkImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    self.checkImage.snp.makeConstraints {
      $0.right.equalToSuperview().offset(-16)
      $0.centerY.equalTo(self.nickTextField)
    }
    self.checkImage.isHidden = true
  }
  
  func updateNickname(nickname: String) {
    self.nickTextField.text = nickname
  }
  
  func updateNicknameSection(state: InputState) {
    Log(state)
    self.nicknameCheckButton.isHidden = state != .correctFormat
    self.checkImage.isHidden = state != .success
    self.nickTextField.textColor = (state == .wrongFormat || state == .duplicate) ? .brick : .blackText
  }
  
  func editTextField() -> Observable<String> {
    self.nickTextField.rx.text.orEmpty.asObservable()
  }
  
  func clickDoubleCheck() -> Observable<Void> {
    self.nicknameCheckButton.rx.tap.asObservable()
  }
}
