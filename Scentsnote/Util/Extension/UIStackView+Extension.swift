//
//  UIStackView+Extension.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit

extension UIStackView {
  static func createInputSection(text: String, textField: UITextField) -> UIStackView {
    let titleLabel = UILabel().then {
      $0.text = text
      $0.font = .notoSans(type: .regular, size: 14)
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
