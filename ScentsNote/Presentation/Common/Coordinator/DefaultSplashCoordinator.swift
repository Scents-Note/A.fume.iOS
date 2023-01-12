//
//  DefaultSplashCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import UIKit

final class DefaultSplashCoordinator: BaseCoordinator, SplashCoordinator {
  
  var finishFlow: (() -> Void)?
  var splashViewController: SplashViewController
  
  override init(_ navigationController: UINavigationController) {
    self.splashViewController = SplashViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.splashViewController.viewModel = SplashViewModel(coordinator: self,
                                                          loginUseCase: LoginUseCase(userRepository: DefaultUserRepository.shared),
                                                          logoutUseCase: LogoutUseCase(userRepository: DefaultUserRepository.shared),
                                                          saveLoginInfoUseCase: SaveLoginInfoUseCase(userRepository: DefaultUserRepository.shared)
    )
    self.navigationController.pushViewController(splashViewController, animated: false)
  }
  
}
