//
//  UIViewController+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit
import Then

extension UIViewController {
  func setNavigationBar(title: String? = nil) {
    self.setBackButton()
    guard let title = title else { return }
    self.setNavigationTitle(title: title)
  }
  
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
  
  func setHomeNavigationTitle(title: String) {
    let titleLabel = UILabel().then {
      $0.text = title
      $0.font = .nanumMyeongjo(type: .extraBold, size: 22)
    }
    let titleButtonItem = UIBarButtonItem(customView: titleLabel)
    self.navigationItem.leftBarButtonItem = titleButtonItem
    self.navigationItem.leftItemsSupplementBackButton = true
  }
}

// MARK: Alert
extension UIViewController {
  func presentAlert(
    title: String? = "",
    message: String,
    completion: (() -> Void)?
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "종료", style: .default, handler: { _ in
      completion?()
      alert.dismiss(animated: true)
    })
    let cancel = UIAlertAction(title : "계속 진행", style: .cancel)
    alert.addAction(ok)
    alert.addAction(cancel)

    self.present(alert, animated: true)
  }
}
