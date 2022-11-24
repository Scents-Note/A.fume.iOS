//
//  DefaultSearchCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultSearchCoordinator: BaseCoordinator, SearchCoordinator {
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  var searchViewController: SearchViewController
  
  override init(_ navigationController: UINavigationController) {
    self.searchViewController = SearchViewController()
    super.init(navigationController)
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
  
  func runSearchKeywordFlow(from: CoordinatorType) {
    let coordinator = DefaultSearchKeywordCoordinator(self.navigationController)
    coordinator.finishFlow = { [weak self, unowned coordinator] perfumeSearch in
      switch from {
      case .search:
        self?.runSearchResultFlow(perfumeSearch: perfumeSearch)
      case .searchResult:
        self?.navigationController.popViewController(animated: true)
        let vc = self?.findViewController(SearchResultViewController.self) as! SearchResultViewController
        vc.viewModel?.updateSearchWords(perfumeSearch: perfumeSearch)
      default:
        break
      }
      self?.removeDependency(coordinator)
    }
    coordinator.start(from: from)
    self.addDependency(coordinator)
  }
  
  func runSearchResultFlow(perfumeSearch: PerfumeSearch) {
    let coordinator = DefaultSearchResultCoordinator(self.navigationController)
    coordinator.runPerfumeDetailFlow = { [weak self] perfumeIdx in
      self?.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.runSearchKeywordFlow = { [weak self] in
      self?.runSearchKeywordFlow(from: .searchResult)
    }
    coordinator.finishFlow = {
      
    }
    coordinator.start(perfumeSearch: perfumeSearch)
    self.addDependency(coordinator)
  }
  
  
  
//  func showSearchKeywordController() {
//    let vc = SearchKeywordViewController()
//    vc.viewModel = SearchKeywordViewModel(coordinator: self, perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared))
//    vc.hidesBottomBarWhenPushed = true
//    self.navigationController.pushViewController(vc, animated: true)
//  }
}
