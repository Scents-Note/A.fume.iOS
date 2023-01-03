//
//  DefaultHomeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultHomeCoordinator: BaseCoordinator, HomeCoordinator {
  
  var viewController: HomeViewController
  
  override init(_ navigationController: UINavigationController) {
    self.viewController = HomeViewController()
    super.init(navigationController)
  }
  
  override func start() {
    let perfumeRepository = DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)
    self.viewController.viewModel = HomeViewModel(coordinator: self,
                                                  fetchUserDefaultUseCase: FetchUserDefaultUseCase(userRepository: DefaultUserRepository(userService: DefaultUserService.shared, userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)),
                                                  updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase(perfumeRepository: perfumeRepository),
                                                  fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase(perfumeRepository: perfumeRepository),
                                                  fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase(perfumeRepository: perfumeRepository),
                                                  fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase(perfumeRepository: perfumeRepository),
                                                  fetchPerfumesNewUseCase: FetchPerfumesNewUseCase(perfumeRepository: perfumeRepository))
    self.navigationController.pushViewController(self.viewController, animated: true)
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    let coordinator = DefaultPerfumeDetailCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self] in
      self.removeDependency(coordinator)
    }
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
}
