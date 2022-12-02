//
//  EditInformationGenderView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class EditInformationGenderView: UIView {
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "성별을 선택해주세요."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 14)
  }
 
  let manLabel = UILabel().then {
    $0.text = "남자"
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 15)
  }
  let womanLabel = UILabel().then {
    $0.text = "여자"
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  let manButton = UIButton().then { $0.setImage(.btnManInactive, for: .normal) }
  let womanButton = UIButton().then { $0.setImage(.btnWomanInactive, for: .normal) }
  private let dividerTop = UIView().then { $0.backgroundColor = .blackText }
  private let dividerCenter = UIView().then { $0.backgroundColor = .blackText }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.blackText.cgColor
    
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview().offset(16)
    }
    
    self.addSubview(self.dividerTop)
    self.dividerTop.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(1)
    }
    
    self.addSubview(self.dividerCenter)
    self.dividerCenter.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.dividerTop.snp.bottom).offset(16)
      $0.height.equalTo(126)
      $0.width.equalTo(0.5)
    }
    
    self.addSubview(self.manButton)
    self.manButton.snp.makeConstraints {
      $0.top.equalTo(self.dividerTop.snp.bottom).offset(16)
      $0.left.equalToSuperview()
      $0.right.equalTo(self.dividerCenter.snp.left)
    }
    
    self.addSubview(self.manLabel)
    self.manLabel.snp.makeConstraints {
      $0.centerX.equalTo(self.manButton)
      $0.top.equalTo(self.manButton.snp.bottom).offset(8)
      $0.bottom.equalTo(-18)
    }
    
    self.addSubview(self.womanButton)
    self.womanButton.snp.makeConstraints {
      $0.top.equalTo(self.dividerTop.snp.bottom).offset(16)
      $0.right.equalToSuperview()
      $0.left.equalTo(self.dividerCenter.snp.right)
    }
    
    self.addSubview(self.womanLabel)
    self.womanLabel.snp.makeConstraints {
      $0.centerX.equalTo(self.womanButton)
      $0.top.equalTo(self.womanButton.snp.bottom).offset(8)
      $0.bottom.equalTo(-18)
    }
  }
  
  func clickManButton() -> Observable<Void> {
    self.manButton.rx.tap.asObservable()
  }
  
  func clickWomanButton() -> Observable<Void> {
    self.womanButton.rx.tap.asObservable()
  }
  
  func updateGenderSection(gender: String) {
    self.manButton.setImage(gender == "MAN" ? .btnManActive : .btnManInactive, for: .normal)
    self.manLabel.textColor = gender == "MAN" ? .blackText : .grayCd
    self.womanButton.setImage(gender == "WOMAN" ? .btnWomanActive : .btnWomanInactive, for: .normal)
    self.womanLabel.textColor = gender == "WOMAN" ? .blackText : .grayCd
  }
}
