//
//  DefaultSignCoordinator.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation
import UIKit

class DefaultSignCoordinator: SignCoordinator {
  
  weak var finishDelegate: CoordinatorFinishDelegate?
  var navigationController: UINavigationController
  var childCoordinators = [Coordinator]()
  var type: CoordinatorType { .sign }
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  func start() {
    <#code#>
  }
  
  func showLoginViewController() {
    <#code#>
  }
  
  func showSignUpViewController() {
    <#code#>
  }
  
  
}
