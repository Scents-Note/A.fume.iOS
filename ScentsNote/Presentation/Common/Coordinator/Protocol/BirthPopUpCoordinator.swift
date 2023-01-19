//
//  BirthPopUpCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/19.
//

import Foundation

protocol BirthPopUpCoordinator: Coordinator {
  func showBirthPopupViewController(with birth: Int?)
  func hideBirthPopupViewController()
  
}
