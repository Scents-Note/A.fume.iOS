//
//  DefaultPerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit

final class DefaultPerfumeDetailCoordinator: BaseCoordinator, PerfumeDetailCoordinator {
  var perfumeDetailViewController: PerfumeDetailViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeDetailViewController = PerfumeDetailViewController()
    super.init(navigationController)
  }
  
  func start(perfumeIdx: Int) {
    self.perfumeDetailViewController.viewModel = PerfumeDetailViewModel(
      coordinator: self,
      fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared),
      perfumeIdx: perfumeIdx
    )
    perfumeDetailViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeDetailViewController, animated: true)
  }
}
