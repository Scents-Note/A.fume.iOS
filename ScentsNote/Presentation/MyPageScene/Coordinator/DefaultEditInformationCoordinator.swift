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
    vc.viewModel = EditInformationViewModel(coordinator: self,
                                     fetchUserInfoForEditUseCase: DefaultFetchUserInfoForEditUseCase(userRepository: DefaultUserRepository.shared),
                                     checkDuplicateNicknameUseCase: DefaultCheckDuplicateNicknameUseCase(userRepository: DefaultUserRepository.shared),
                                     updateUserInformationUseCase: DefaultUpdateUserInformationUseCase(userRepository: DefaultUserRepository.shared),
                                     saveUserInfoUseCase: DefaultSaveEditUserInfoUseCase(userRepository: DefaultUserRepository.shared))
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
  
  func showWebViewController(with url: String) {
    let coordinator = DefaultWebCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(with: url)
    self.addDependency(coordinator)
  }
}
