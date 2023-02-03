//
//  DefaultSplashCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import UIKit

final class DefaultSplashCoordinator: BaseCoordinator, SplashCoordinator {
  
  // MARK: - Navigate
  var finishFlow: (() -> Void)?
  
  // MARK: - ViewController
  var splashViewController: SplashViewController
  
  override init(_ navigationController: UINavigationController) {
    self.splashViewController = SplashViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showSplashViewController()
  }
  
  func showSplashViewController() {
    self.splashViewController.viewModel = SplashViewModel(coordinator: self,
                                                          loginUseCase: DefaultLoginUseCase(userRepository: DefaultUserRepository.shared),
                                                          logoutUseCase: DefaultLogoutUseCase(userRepository: DefaultUserRepository.shared),
                                                          saveLoginInfoUseCase: DefaultSaveLoginInfoUseCase(userRepository: DefaultUserRepository.shared)
    )
    self.navigationController.pushViewController(self.splashViewController, animated: false)
    
  }
  
}
