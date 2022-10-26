//
//  DefaultLoginCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultLoginCoordinator: LoginCoordinator {
  weak var finishDelegate: CoordinatorFinishDelegate?
  weak var loginFinishDelegate: LoginCoordinatorDidFinishDelegate?

  var navigationController: UINavigationController
  var loginViewController: LoginViewController
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorType = .login
  
  init(_ navigationContoller: UINavigationController) {
    self.navigationController = navigationContoller
    self.loginViewController = LoginViewController()
  }
  
  func start() {}
  
  func showLoginViewController() {
      self.loginViewController.viewModel = LoginViewModel(
          coordinator: self,
          userRepository: DefaultUserRepository(userService: DefaultUserService())
      )
      self.navigationController.pushViewController(self.loginViewController, animated: true)
  }
  
  func finish() {
    print("User Log: finish")
    self.loginFinishDelegate?.loginCoordinatorDidFinish()
  }
}
