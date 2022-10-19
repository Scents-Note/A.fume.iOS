//
//  DefaultSignUpCoordinator.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit

final class DefaultSignUpCoordinator: SignUpCoordinator {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var navigationController: UINavigationController
  var signUpViewController: SignUpViewController
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorType = .login
  
  init(_ navigationContoller: UINavigationController) {
    self.navigationController = navigationContoller
    self.signUpViewController = SignUpViewController()
  }
  
  func start() {}
  
  func showSignUpViewController() {
      self.signUpViewController.viewModel = SignUpViewModel(
          coordinator: self
      )
      self.navigationController.pushViewController(self.signUpViewController, animated: true)
  }
  
  func finish() {
      self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
