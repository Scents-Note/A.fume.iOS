//
//  BaseNavigationController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/17.
//

import UIKit
import Then

class BaseNavigationController: UINavigationController {

  private let titleLabel = UILabel().then {
    $0.font = .nanumMyeongjo(type: .extraBold, size: 18)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationBarHidden(true, animated: false)
    self.interactivePopGestureRecognizer?.delegate = nil
    self.navigationBar.barTintColor = .white
    self.navigationBar.backIndicatorImage = UIImage()
    self.navigationBar.backIndicatorTransitionMaskImage = UIImage()
    self.navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.blackText
    ]
//    self.navigationItem.titleView = self.configureNavigationBar1()

  }
  
  func configureNavigationBar1() -> UIStackView {
    let titleLabel = UILabel()
    titleLabel.text = "rrrrr"
    titleLabel.font = .nanumMyeongjo(type: .extraBold, size: 18)
    
    let spacer = UIView()
    let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
    constraint.isActive = true
    constraint.priority = .defaultLow

    let stack = UIStackView(arrangedSubviews: [self.titleLabel, spacer])
    stack.axis = .horizontal
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.layoutIfNeeded()
    stack.translatesAutoresizingMaskIntoConstraints = true
    return stack
  }
  
}
