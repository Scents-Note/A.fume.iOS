//
//  BaseCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import UIKit

class BaseCoordinator: Coordinator {
  
  // MARK: - Vars & Lets
  var navigationController: UINavigationController
  var childCoordinators = [Coordinator]()
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func addDependency(_ coordinator: Coordinator) {
    for element in childCoordinators {
      if element === coordinator { return }
    }
    childCoordinators.append(coordinator)
  }
  
  func removeDependency(_ coordinator: Coordinator?) {
    guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
    
    for (index, element) in childCoordinators.enumerated() {
      if element === coordinator {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
  
  func findViewController<T: UIViewController>(_ viewController: T.Type) -> UIViewController? {
    for element in navigationController.viewControllers {
      if type(of: element) == viewController {
        return element
      }
    }
    return nil
  }
  
  // MARK: - Coordinator
  func start() {}
  func start(from: CoordinatorType) {}
}

