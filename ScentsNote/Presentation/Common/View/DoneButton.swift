//
//  DoneButton.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
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
    self.setTitle("다음", for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font = .notoSans(type: .bold, size: 15)
    self.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)
    self.setImage(.btnNext, for: .normal)
    self.contentHorizontalAlignment = .right
    self.layer.backgroundColor = UIColor.blackText.cgColor
    self.semanticContentAttribute = .forceRightToLeft
    self.contentEdgeInsets = .init(top: 0, left: 10, bottom: 34, right: 20)
  }
}
