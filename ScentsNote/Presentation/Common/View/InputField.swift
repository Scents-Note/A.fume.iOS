//
//  InputField.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
//

import UIKit
import SnapKit
import Then

class InputField: UITextField {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.textColor = .blackText
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
