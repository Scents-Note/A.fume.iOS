//
//  DefaultPerfumeNewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit

final class DefaultPerfumeNewCoordinator: BaseCoordinator, PerfumeNewCoordinator {
  
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  var navigationController: UINavigationController
  var perfumeNewViewController: PerfumeNewViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.perfumeNewViewController = PerfumeNewViewController()
  }
  
  override func start() {
    self.perfumeNewViewController.viewModel = PerfumeNewViewModel(
      coordinator: self,
      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)
    )
    self.perfumeNewViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeNewViewController, animated: true)
  }
  
  
}
