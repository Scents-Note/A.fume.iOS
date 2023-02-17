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
                                                          checkIsSupportableVersionUseCase: DefaultCheckIsSupportableVersionUseCase(systemRepository: DefaultSystemRepository.shared),
                                                          loginUseCase: DefaultLoginUseCase(userRepository: DefaultUserRepository.shared),
                                                          logoutUseCase: DefaultLogoutUseCase(userRepository: DefaultUserRepository.shared),
                                                          saveLoginInfoUseCase: DefaultSaveLoginInfoUseCase(userRepository: DefaultUserRepository.shared)
    )
    self.navigationController.pushViewController(self.splashViewController, animated: false)
    
  }
  
  func showPopup() {
    let vc = LabelPopupViewController().then {
      $0.setButtonState(state: .one)
      $0.setLabel(content: "최적의 서비스 이용을 위해\n최신 버전으로 업데이트가 필요합니다")
      $0.setConfirmLabel(content: "앱 업데이트")
    }
    vc.viewModel = LabelPopupViewModel(coordinator: self,
                                       delegate: self.splashViewController.viewModel!)
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hidePopup() {
    self.navigationController.dismiss(animated: false)
  }
}
