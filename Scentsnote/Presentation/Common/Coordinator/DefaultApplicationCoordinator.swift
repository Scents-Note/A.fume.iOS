//
//  DefaultApplicationCoordinator.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultApplicationCoordinator: ApplicationCoordinator {
  
  weak var finishDelegate: CoordinatorFinishDelegate?
  var navigationController: UINavigationController
  var childCoordinators = [Coordinator]()
  var type: CoordinatorType { .app }
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  func start() {
    
  }
  
  func runSigningFlow() {
//    let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
//    loginCoordinator.finishDelegate = self
//    loginCoordinator.start()
//    childCoordinators.append(loginCoordinator)
  }
}

extension DefaultApplicationCoordinator: CoordinatorFinishDelegate {
  func coordinatorDidFinish(childCoordinator: Coordinator) {
    self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    
    self.navigationController.view.backgroundColor = .systemBackground
    self.navigationController.viewControllers.removeAll()
    
    switch childCoordinator.type {
    case .signing:
      self.runSigningFlow()
    default:
      break
    }
  }
}
