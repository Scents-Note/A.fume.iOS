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
    self.viewController.viewModel = HomeViewModel(
      coordinator: self,
      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService())
    )
    self.navigationController.pushViewController(self.viewController, animated: true)
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    let coordinator = DefaultPerfumeDetailCoordinator(self.navigationController)
    coordinator.runPerfumeReviewFlow = { perfumeDetail in
      self.runPerfumeReviewFlow(perfumeDetail: perfumeDetail)
    }
    coordinator.runPerfumeDetailFlow = { perfumeIdx in
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
}
