//
//  DefaultPerfumeNewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit

final class DefaultPerfumeNewCoordinator: BaseCoordinator, PerfumeNewCoordinator {
  
  var runPerfumeDetailFlow: ((Int) -> Void)?

  var perfumeNewViewController: PerfumeNewViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeNewViewController = PerfumeNewViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.perfumeNewViewController.viewModel = PerfumeNewViewModel(
      coordinator: self,
      fetchPerfumesNewUseCase: DefaultFetchPerfumesNewUseCase(perfumeRepository: DefaultPerfumeRepository.shared)
    )
    self.perfumeNewViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeNewViewController, animated: true)
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
}
