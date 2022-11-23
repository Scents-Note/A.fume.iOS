//
//  DefaultHomeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultHomeCoordinator: BaseCoordinator, HomeCoordinator {
  
  var navigationController: UINavigationController
  var viewController: HomeViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.viewController = HomeViewController()
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
//    perfumeCoordinator.finishFlow = { [unowned self, unowned perfumeCoordinator] in
//      self.removeDependency(perfumeCoordinator)
//    }
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
}
