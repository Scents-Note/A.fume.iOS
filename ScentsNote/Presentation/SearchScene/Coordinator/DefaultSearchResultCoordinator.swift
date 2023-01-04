//
//  DefaultSearchResultCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit

final class DefaultSearchResultCoordinator: BaseCoordinator, SearchResultCoordinator {

  var finishFlow: (() -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  var runSearchKeywordFlow: (() -> Void)?
  var runSearchFilterFlow: (() -> Void)?

  var searchResultViewController: SearchResultViewController
  
  override init(_ navigationController: UINavigationController) {
    self.searchResultViewController = SearchResultViewController()
    super.init(navigationController)
  }
  
  func start(perfumeSearch: PerfumeSearch) {
    self.searchResultViewController.viewModel = SearchResultViewModel(coordinator: self,
                                                                      fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
                                                                      perfumeSearch: perfumeSearch)
    
//    self.searchResultViewController.hidesBottomBarWhenPushed = false
    self.navigationController.pushViewController(self.searchResultViewController, animated: true)
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
