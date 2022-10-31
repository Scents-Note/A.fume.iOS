//
//  SignUpCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation

protocol LoginCoordinator: AnyObject {
  var finishFlow: (() -> Void)? { get set }
  var onSignUpFlow: (() -> Void)? { get set }
  func showLoginViewController()
}
