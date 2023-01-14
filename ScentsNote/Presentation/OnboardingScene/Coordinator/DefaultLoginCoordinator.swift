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
    self.loginViewController.viewModel = LoginViewModel(coordinator: self,
                                                        loginUseCase: DefaultLoginUseCase(userRepository: DefaultUserRepository.shared),
                                                        saveLoginInfoUseCase: DefaultSaveLoginInfoUseCase(userRepository: DefaultUserRepository.shared))
    
    self.navigationController.pushViewController(self.loginViewController, animated: true)
  }
  
}
