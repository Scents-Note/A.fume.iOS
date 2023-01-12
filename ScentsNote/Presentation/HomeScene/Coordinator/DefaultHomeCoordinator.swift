//
//  DefaultHomeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import Then

final class DefaultHomeCoordinator: BaseCoordinator, HomeCoordinator {
  
  var runOnboardingFlow: (() -> Void)?
  var viewController: HomeViewController
  
  override init(_ navigationController: UINavigationController) {
    self.viewController = HomeViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.viewController.viewModel = HomeViewModel(coordinator: self,
                                                  fetchUserDefaultUseCase: FetchUserDefaultUseCase(userRepository: DefaultUserRepository.shared),
                                                  updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                  fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                  fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                  fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                  fetchPerfumesNewUseCase: FetchPerfumesNewUseCase(perfumeRepository: DefaultPerfumeRepository.shared))
    self.navigationController.pushViewController(self.viewController, animated: true)
  }
  
  
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    let coordinator = DefaultPerfumeDetailCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self] in
      self.removeDependency(coordinator)
    }
    coordinator.runOnboardingFlow = runOnboardingFlow
    coordinator.runPerfumeReviewFlow = { [unowned self] perfumeDetail in
      self.runPerfumeReviewFlow(perfumeDetail: perfumeDetail)
    }
    coordinator.runPerfumeReviewFlowWithReviewIdx = { [unowned self] reviewIdx in
      self.runPerfumeReviewFlow(reviewIdx: reviewIdx)
    }
    coordinator.runPerfumeDetailFlow = { [unowned self] perfumeIdx in
      self.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.start(perfumeIdx: perfumeIdx)
    self.addDependency(coordinator)
  }
  
  func runPerfumeNewFlow() {
    let coordinator = DefaultPerfumeNewCoordinator(self.navigationController)
    coordinator.runPerfumeDetailFlow = { perfumeIdx in
      self.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.start()
    self.addDependency(coordinator)
  }
  
  func runPerfumeReviewFlow(perfumeDetail: PerfumeDetail) {
    let coordinator = DefaultPerfumeReviewCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(perfumeDetail: perfumeDetail)
    self.addDependency(coordinator)
  }
  
  func runPerfumeReviewFlow(reviewIdx: Int) {
    let coordinator = DefaultPerfumeReviewCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(reviewIdx: reviewIdx)
    self.addDependency(coordinator)
  }
  
  func showPopup() {
    let vc = LabelPopupViewController().then {
      $0.setLabel(content: "로그인 후 사용 가능합니다.\n로그인을 해주세요.")
      $0.setConfirmLabel(content: "로그인 하기")
    }
    vc.viewModel = LabelPopupViewModel(
      coordinator: self,
      delegate: self.viewController.viewModel!
    )
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hidePopup() {
    self.navigationController.dismiss(animated: false)
  }
}
