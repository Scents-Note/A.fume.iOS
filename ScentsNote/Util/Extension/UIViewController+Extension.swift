//
//  UIViewController+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit
import Then

extension UIViewController {
  func setBackButton() {
    let backImage = UIImage(named: "btnBack")
    let backBarButtonItem = BackBarButtonItem(image: backImage, style: .plain, target: nil, action: nil)
    backBarButtonItem.tintColor = .blackText
    self.navigationItem.backBarButtonItem = backBarButtonItem
  }
  
  func setNavigationTitle(title: String) {
    let titleLabel = UILabel().then {
      $0.text = title
      $0.font = .nanumMyeongjo(type: .extraBold, size: 18)
    }
    let titleButtonItem = UIBarButtonItem(customView: titleLabel)
    self.navigationItem.leftBarButtonItem = titleButtonItem
    self.navigationItem.leftItemsSupplementBackButton = true
  }
}
