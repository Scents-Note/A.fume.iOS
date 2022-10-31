//
//  BaseNavigationController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/17.
//

import UIKit
import Then

class BaseNavigationController: UINavigationController {
  
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
  }
}
