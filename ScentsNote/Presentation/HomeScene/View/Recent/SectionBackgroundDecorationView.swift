//
//  Ba.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit

class SectionBackgroundDecorationView: UICollectionReusableView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .lightGray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
