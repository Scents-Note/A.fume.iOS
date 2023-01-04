//
//  DefaultSplashCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import UIKit

final class DefaultSplashCoordinator: BaseCoordinator, SplashCoordinator {
  
  var finishFlow: (() -> Void)?
  var viewController: SplashViewController
  
  override init(_ navigationController: UINavigationController) {
    self.viewController = SplashViewController()
    super.init(navigationController)
  }
  
  override func start() {
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
    self.viewController.viewModel = SplashViewModel(
      coordinator: self,
      loginUseCase: LoginUseCase(userRepository: userRepository),
      logoutUseCase: LogoutUseCase(userRepository: userRepository),
      saveLoginInfoUseCase: SaveLoginInfoUseCase(userRepository: userRepository)
    )
    self.navigationController.pushViewController(viewController, animated: false)
  }
  
}
