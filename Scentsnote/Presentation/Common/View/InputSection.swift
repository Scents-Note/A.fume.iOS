//
//  InputSection.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit

class InputSection: UIStackView {
  
  
  required init(title: String, textField: UITextField){
    super.init(frame: .zero)
    self.setupView(title: title, textField: textField)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(title: String, textField: UITextField) {
    
    self.axis = .vertical
    self.alignment = .fill
    self.spacing = 10
    
    let titleLabel = UILabel().then {
      $0.text = title
      $0.font = .notoSans(type: .regular, size: 14)
      $0.textColor = .darkGray7d
    }
    
    self.addArrangedSubview(titleLabel)
    self.addArrangedSubview(textField)
  }
  
}
