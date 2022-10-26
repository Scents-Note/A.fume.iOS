//
//  DefaultSignUpCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit

final class DefaultSignUpCoordinator: SignUpCoordinator {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators: [Coordinator] = []
  var userRepository: UserRepository
  var navigationController: UINavigationController
  var type: CoordinatorType = .login
  
  init(_ navigationContoller: UINavigationController) {
    self.navigationController = navigationContoller
    self.userRepository = DefaultUserRepository(userService: DefaultUserService())
  }
  
  func start() {}
  
  func showSignUpInformationViewController() {
    let signUpInformationViewController = SignUpInformationViewController()
    signUpInformationViewController.viewModel = SignUpInformationViewModel(
      coordinator: self,
      userRepository: userRepository
    )
    self.navigationController.pushViewController(signUpInformationViewController, animated: true)
  }
  
  func showSignUpPasswordViewController(with signUpInfo: SignUpInfo) {
    let signUpPasswordViewController = SignUpPasswordViewController()
    signUpPasswordViewController.viewModel = SignUpPasswordViewModel(
      coordinator: self,
      userRepository: userRepository,
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(signUpPasswordViewController, animated: true)
  }
  
  func finish() {
    self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
