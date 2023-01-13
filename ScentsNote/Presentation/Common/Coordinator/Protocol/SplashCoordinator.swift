//
//  SplashCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import Foundation

protocol SplashCoordinator: AnyObject {
  var finishFlow: (() -> Void)? { get set }
  func showSplashViewController()
}
