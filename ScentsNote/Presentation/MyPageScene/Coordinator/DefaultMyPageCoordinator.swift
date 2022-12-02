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
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
    self.myPageViewController.viewModel = MyPageViewModel(
      coordinator: self,
      fetchPerfumesLikedUseCase: FetchPerfumesLikedUseCase(userRepository: userRepository)
    )
    self.navigationController.pushViewController(self.myPageViewController, animated: true)
  }
  
  func runEditInfoFlow() {
    let coordinator = DefaultEditInformationCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start()
    self.addDependency(coordinator)
  }
  
  func runChangePasswordFlow() {
    let coordinator = DefaultChangePasswordCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start()
    self.addDependency(coordinator)
  }
  
  func runWebFlow(with url: String) {
    let coordinator = DefaultWebCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(with: url)
    self.addDependency(coordinator)
  }
  
  func showMyPageMenuViewController() {
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
    let vc = MyPageMenuViewController()
    vc.viewModel = MyPageMenuViewModel(
      coordinator: self,
      userRepository: userRepository
    )
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hideMyPageMenuViewController() {
    self.navigationController.dismiss(animated: false)
  }
  
}
