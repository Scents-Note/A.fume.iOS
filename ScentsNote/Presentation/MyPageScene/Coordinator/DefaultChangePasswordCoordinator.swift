//
//  DefaultChangePasswordCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit

final class DefaultChangePasswordCoordinator: BaseCoordinator, ChangePasswordCoordinator {
  
  var finishFlow: (() -> Void)?
  
  var changePasswordViewController: ChangePasswordViewController
  
  override init(_ navigationController: UINavigationController) {
    self.changePasswordViewController = ChangePasswordViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showChangePasswordViewController()
  }
  
  private func showChangePasswordViewController() {
    let vc = self.changePasswordViewController
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
    vc.viewModel = ChangePasswordViewModel(coordinator: self,
                                           fetchUserPasswordUseCase: FetchUserPasswordUseCase(userRepository: userRepository),
                                           changePasswordUseCase: ChangePasswordUseCase(userRepository: userRepository),
                                           savePasswordUseCase: SavePasswordUseCase(userRepository: userRepository))
    vc.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  
}
