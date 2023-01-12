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
    vc.viewModel = ChangePasswordViewModel(coordinator: self,
                                           fetchUserPasswordUseCase: FetchUserPasswordUseCase(userRepository: DefaultUserRepository.shared),
                                           changePasswordUseCase: ChangePasswordUseCase(userRepository: DefaultUserRepository.shared),
                                           savePasswordUseCase: SavePasswordUseCase(userRepository: DefaultUserRepository.shared))
    vc.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  
}
