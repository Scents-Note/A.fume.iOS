//
//  DoneButton.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import UIKit

class DoneButton: UIButton {
  
  required init(frame: CGRect, title: String) {
    super.init(frame: .zero)
    self.setTitle(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setTitle(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font = .notoSans(type: .bold, size: 15)
    self.layer.backgroundColor = UIColor.blackText.cgColor
    self.contentEdgeInsets = .init(top: 0, left: 0, bottom: 34, right: 0)
  }
  
  func updateTitle(title: String) {
    self.setTitle(title, for: .normal)
  }
}
