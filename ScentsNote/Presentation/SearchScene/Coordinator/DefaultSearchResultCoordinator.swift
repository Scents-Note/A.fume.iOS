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

  var searchResultViewController: SearchResultViewController
  
  override init(_ navigationController: UINavigationController) {
    self.searchResultViewController = SearchResultViewController()
    super.init(navigationController)
  }
  
  func start(perfumeSearch: PerfumeSearch) {
    self.searchResultViewController.viewModel = SearchResultViewModel(coordinator: self,
                                                                      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared),
                                                                      perfumeSearch: perfumeSearch)
    
//    self.searchResultViewController.hidesBottomBarWhenPushed = false
    self.navigationController.pushViewController(self.searchResultViewController, animated: true)
  }
}
