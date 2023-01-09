//
//  CheckDuplicationButton.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/26.
//

import UIKit

class DoubleCheckButton: UIButton {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override init(frame: CGRect){
    super.init(frame: frame)
    self.setTitle("중복확인", for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.layer.backgroundColor = UIColor.blackText.cgColor
    self.layer.cornerRadius = 2
    self.titleLabel?.font = .notoSans(type: .regular, size: 14)
    self.contentEdgeInsets =  .init(top: 5, left: 10, bottom: 5, right: 10)
  }
}

