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
      fetchPerfumesNewUseCase: FetchPerfumesNewUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared))
    )
    self.perfumeNewViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeNewViewController, animated: true)
  }
}
