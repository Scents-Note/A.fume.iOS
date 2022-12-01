//
//  EditInfoCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import Foundation

protocol EditInfoCoordinator: AnyObject {

  var finishFlow: (() -> Void)? { get set }
  
  func showBirthPopupViewController(with birth: Int)
  func hideBirthPopupViewController()
}
