//
//  DefaultMypageCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultMyPageCoordinator: BaseCoordinator, MyPageCoordinator {
  
  var onOnboardingFlow: (() -> Void)?
  
  var myPageViewController: MyPageViewController
  override init(_ navigationController: UINavigationController) {
    self.myPageViewController = MyPageViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.myPageViewController.viewModel = MyPageViewModel(
      coordinator: self,
      fetchPerfumesLikedUseCase: FetchPerfumesLikedUseCase(userRepository: DefaultUserRepository(userService: DefaultUserService.shared))
    )
    self.navigationController.pushViewController(self.myPageViewController, animated: true)
  }
  
  func showMyPageMenuViewController() {
    let vc = MyPageMenuViewController()
    vc.viewModel = MyPageMenuViewModel(
      coordinator: self,
      userRepository: DefaultUserRepository(userService: DefaultUserService.shared)
    )
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func runEditInfoFlow() {
    let coordinator = DefaultEditInfoCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    
    coordinator.start()
    self.addDependency(coordinator)
  }
  
  func showChangePasswordViewController() {
    
  }
  
  func showWebViewController() {
    
  }
  
  func hideMyPageMenuViewController() {
    self.navigationController.dismiss(animated: false)
  }
  
  
  
}
