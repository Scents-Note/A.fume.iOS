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
  
  func runPerfumeKeywordFlow() {
    let coordinator = DefaultSearchKeywordCoordinator(self.navigationController)
    coordinator.finishFlow = { [weak self] perfumeSearch in
      self?.runPerfumeResultFlow(perfumeSearch: perfumeSearch)
    }
    coordinator.start()
    self.addDependency(coordinator)
  }
  
  func runPerfumeResultFlow(perfumeSearch: PerfumeSearch) {
    let coordinator = DefaultSearchResultCoordinator(self.navigationController)
    coordinator.finishFlow = {
      
    }
    coordinator.start()
    self.addDependency(coordinator)
  }
  
  
  
//  func showSearchKeywordController() {
//    let vc = SearchKeywordViewController()
//    vc.viewModel = SearchKeywordViewModel(coordinator: self, perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared))
//    vc.hidesBottomBarWhenPushed = true
//    self.navigationController.pushViewController(vc, animated: true)
//  }
}
