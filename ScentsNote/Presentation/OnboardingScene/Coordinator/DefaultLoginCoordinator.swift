//
//  DefaultLoginCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultLoginCoordinator: BaseCoordinator, LoginCoordinator {
  
  var finishFlow: (() -> Void)?
  var onSignUpFlow: (() -> Void)?

//  weak var finishDelegate: CoordinatorFinishDelegate?
//  weak var onSignUpDelegate: OnSignUpCoordinatorDelegate?

  var navigationController: UINavigationController
  var loginViewController: LoginViewController
  
  init(_ navigationContoller: UINavigationController) {
    self.navigationController = navigationContoller
    self.loginViewController = LoginViewController()
  }
  
  override func start() {
    self.showLoginViewController()
  }
  
  func showLoginViewController() {
      self.loginViewController.viewModel = LoginViewModel(
          coordinator: self,
          userRepository: DefaultUserRepository(userService: DefaultUserService())
      )
      self.navigationController.pushViewController(self.loginViewController, animated: true)
  }
  
  func finish() {
//    self.onSignUpDelegate?.onSignUpCoordinator()
  }
}
