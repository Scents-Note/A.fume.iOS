//
//  DefaultLoginCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultLoginCoordinator: BaseCoordinator, LoginCoordinator {
  
  var finishFlow: (() -> Void)?
  var runSignUpFlow: (() -> Void)?
  
  var loginViewController: LoginViewController
  
  override init(_ navigationController: UINavigationController) {
    self.loginViewController = LoginViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showLoginViewController()
  }
  
  func showLoginViewController() {
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
    self.loginViewController.viewModel = LoginViewModel(coordinator: self,
                                                        loginUseCase: LoginUseCase(userRepository: userRepository),
                                                        saveLoginInfoUseCase: SaveLoginInfoUseCase(userRepository: userRepository))
    
    self.navigationController.pushViewController(self.loginViewController, animated: true)
  }
  
}
