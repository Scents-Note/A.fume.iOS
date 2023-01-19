//
//  DefaultMypageCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultMyPageCoordinator: BaseCoordinator, MyPageCoordinator {
  
  var runOnboardingFlow: (() -> Void)?
  
  var myPageViewController: MyPageViewController
  override init(_ navigationController: UINavigationController) {
    self.myPageViewController = MyPageViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.myPageViewController.viewModel = MyPageViewModel(coordinator: self,
                                                          fetchUserDefaultUseCase: DefaultFetchUserDefaultUseCase(userRepository: DefaultUserRepository.shared),
                                                          fetchReviewsInMyPageUseCase: DefaultFetchReviewsInMyPageUseCase(userRepository: DefaultUserRepository.shared),
                                                          fetchPerfumesInMyPageUseCase: DefaultFetchPerfumesInMyPageUseCase(userRepository: DefaultUserRepository.shared))
    
    self.navigationController.pushViewController(self.myPageViewController, animated: true)
  }
  
  func runPerfumeReviewFlow(reviewIdx: Int) {
    let coordinator = DefaultPerfumeReviewCoordinator(self.navigationController)
    coordinator.runPerfumeDetailFlow = { [unowned self] perfumeIdx in
      self.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(reviewIdx: reviewIdx)
    self.addDependency(coordinator)
  }
  
  func runPerfumeReviewFlow(perfumeDetail: PerfumeDetail) {
    let coordinator = DefaultPerfumeReviewCoordinator(self.navigationController)
    coordinator.runPerfumeDetailFlow = { [unowned self] perfumeIdx in
      self.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(perfumeDetail: perfumeDetail)
    self.addDependency(coordinator)
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    let coordinator = DefaultPerfumeDetailCoordinator(self.navigationController)
    coordinator.runPerfumeReviewFlow = { [unowned self] perfumeDetail in
      self.runPerfumeReviewFlow(perfumeDetail: perfumeDetail)
    }
    coordinator.runPerfumeReviewFlowWithReviewIdx = { [unowned self] reviewIdx in
      self.runPerfumeReviewFlow(reviewIdx: reviewIdx)
    }
    coordinator.runPerfumeDetailFlow = { perfumeIdx in
      self.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.start(perfumeIdx: perfumeIdx)
    self.addDependency(coordinator)
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
    guard let pvc = self.navigationController.viewControllers.last as? MyPageViewController else {
      return
    }
    
    let vc = MyPageMenuViewController()
    vc.viewModel = MyPageMenuViewModel(coordinator: self,
                                       fetchUserDefaultUseCase: DefaultFetchUserDefaultUseCase(userRepository: DefaultUserRepository.shared),
                                       logoutUseCase: DefaultLogoutUseCase(userRepository: DefaultUserRepository.shared))
    vc.viewModel?.delegate = pvc.viewModel
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hideMyPageMenuViewController() {
    self.navigationController.dismiss(animated: false)
  }
}
