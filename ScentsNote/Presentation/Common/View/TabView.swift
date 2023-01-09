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
  private let tabCnt: Int
  private lazy var tabStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .grayCd }
  
  // MARK: - Life Cycle
  init(buttons: [UIButton], highlight: UIView) {
    self.tabCnt = buttons.count
    super.init(frame: .zero)
    self.setupView(buttons: buttons)
    self.configureUI(buttons: buttons, highlightView: highlight)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure UI
  private func setupView(buttons: [UIButton]) {
    
  }
  
  private func configureUI(buttons: [UIButton], highlightView: UIView) {
    buttons.forEach {
      self.tabStackView.addArrangedSubview($0)
    }
    
    self.addSubview(self.tabStackView)
    self.tabStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.bottom.equalTo(self.tabStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.addSubview(highlightView)
    highlightView.snp.makeConstraints {
      $0.width.equalTo(Int(UIScreen.main.bounds.width) / self.tabCnt)
      $0.bottom.equalTo(self.tabStackView)
      $0.height.equalTo(4)
    }
  }
}
