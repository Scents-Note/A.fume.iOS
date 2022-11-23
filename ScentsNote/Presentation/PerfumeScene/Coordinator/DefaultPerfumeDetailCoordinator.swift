//
//  DefaultPerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit

final class DefaultPerfumeDetailCoordinator: BaseCoordinator, PerfumeDetailCoordinator {
  var navigationController: UINavigationController
  var perfumeDetailViewController: PerfumeDetailViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.perfumeDetailViewController = PerfumeDetailViewController()
  }
  
  func start(perfumeIdx: Int) {
    self.perfumeDetailViewController.viewModel = PerfumeDetailViewModel(
      coordinator: self,
      fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      perfumeIdx: perfumeIdx
    )
    perfumeDetailViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeDetailViewController, animated: true)
  }
}
