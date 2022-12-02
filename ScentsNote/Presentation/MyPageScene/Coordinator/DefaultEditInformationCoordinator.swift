//
//  DefaultEditInfoCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit

final class DefaultEditInformationCoordinator: BaseCoordinator, EditInformationCoordinator {
  
  var finishFlow: (() -> Void)?
  
  var editInfoViewController: EditInformationViewController
  
  override init(_ navigationController: UINavigationController) {
    self.editInfoViewController = EditInformationViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showEditInfoController()
  }
  
  private func showEditInfoController() {
    let vc = self.editInfoViewController
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
    vc.viewModel = EditInformationViewModel(coordinator: self,
                                     fetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase(userRepository: userRepository),
                                     checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase(userRepository: userRepository),
                                     updateUserInformationUseCase: UpdateUserInformationUseCase(userRepository: userRepository),
                                     saveUserInfoUseCase: SaveUserInfoUseCase(userRepository: userRepository))
    vc.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showBirthPopupViewController(with birth: Int) {
    guard let viewController = self.navigationController.viewControllers.last as? EditInformationViewController else {
      return
    }
    
    let birthPopupViewController = BirthPopupViewController()
    birthPopupViewController.delegate = viewController
    birthPopupViewController.viewModel = BirthPopupViewModel(editInfoCoordinator: self,
                                                             birth: birth,
                                                             from: .myPage)
    birthPopupViewController.modalPresentationStyle = .overFullScreen
    self.navigationController.present(birthPopupViewController, animated: false, completion: nil)
  }
  
  func hideBirthPopupViewController() {
    self.navigationController.dismiss(animated: false)
  }
}
