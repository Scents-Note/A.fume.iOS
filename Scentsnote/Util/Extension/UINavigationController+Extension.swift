//
//  UINavigationController+Extension.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/17.
//

import UIKit

extension UINavigationController {
  
  func setBackgroundColor() {
    navigationBar.barTintColor = UIColor.white
    navigationBar.isTranslucent = false
  }
  
  func setNavigationBackButton() -> UIBarButtonItem {
    let backImage = UIImage(named: "btnBack")
    let backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: nil)
    backBarButtonItem.image = backImage
    backBarButtonItem.tintColor = .blackText
    return backBarButtonItem
//    self.navigationItem.backBarButtonItem = backBarButtonItem
  }
  
  func setNavigationTitle(title: String) -> UIStackView {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .nanumMyeongjo(type: .extraBold, size: 18)
    
    let spacer = UIView()
    let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
    constraint.isActive = true
    constraint.priority = .defaultLow

    let stack = UIStackView(arrangedSubviews: [titleLabel, spacer])
    stack.axis = .horizontal
    return stack
  }
}
