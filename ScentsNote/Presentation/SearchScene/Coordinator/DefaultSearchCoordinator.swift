//
//  DefaultSearchCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultSearchCoordinator: BaseCoordinator, SearchCoordinator {
  
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  var navigationController: UINavigationController
  var searchViewController: SearchViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.searchViewController = SearchViewController()
  }
  
  override func start() {
    self.searchViewController.viewModel = SearchViewModel(
      coordinator: self,
      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)
    )
    self.navigationController.pushViewController(self.searchViewController, animated: true)
  }
  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    let coordinator = DefaultPerfumeDetailCoordinator(self.navigationController)
    coordinator.start(perfumeIdx: perfumeIdx)
    self.addDependency(coordinator)
  }
  
  func showSearchKeywordController() {
    let vc = SearchKeywordController()
    vc.viewModel = SearchKeywordViewModel(
      coordinator: self,
      filterRepository: FilterRepository
    )
    self.navigationController.pushViewController(vc, animated: true)
  }
}
