//
//  TabView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/22.
//

import UIKit
import SnapKit
import Then

final class Tabview: UIView {
  
  // MARK: - UI
  private lazy var tabStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .grayCd }
  private let highlightView = UIView().then { $0.backgroundColor = .black }
  
  
  // MARK: - Life Cycle
  init(buttons: [UIButton]) {
    super.init(frame: .zero)
    self.setupView(buttons: buttons)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure UI
  private func setupView(buttons: [UIButton]) {
    buttons.forEach {
      self.tabStackView.addArrangedSubview($0)
    }
  }
  
  private func configureUI() {
    self.addSubview(self.tabStackView)
    self.tabStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalTo(self.tabStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.addSubview(self.highlightView)
    self.highlightView.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width / 2)
      $0.bottom.equalTo(self.dividerView)
      $0.height.equalTo(4)
    }
    
  }
  
}
