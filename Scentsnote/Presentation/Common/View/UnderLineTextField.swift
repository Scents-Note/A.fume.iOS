//
//  UnderLineTextField.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/17.
//

import UIKit
import SnapKit
import Then

class UnderLineTextField: UITextField {
  
  private let underLineView = UIView().then {
    $0.backgroundColor = .blackText
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //underline 추가 및 레이아웃 설정
    self.textColor = .blackText
    addSubview(underLineView)
    
    underLineView.snp.makeConstraints {
      $0.top.equalTo(self.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setPlaceholder(string: String) {
    
    let font: UIFont = UIFont.nanumMyeongjo(type: .regular, size: 18)
    let placeholderColor: UIColor = .grayCd
    self.attributedPlaceholder = NSAttributedString(
      string: string,
      attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font : font]
    )
  }
}
