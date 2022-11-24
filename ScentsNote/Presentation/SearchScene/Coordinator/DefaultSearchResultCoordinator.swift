//
//  DefaultSearchResultCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit

final class DefaultSearchResultCoordinator: BaseCoordinator, SearchResultCoordinator {

  var finishFlow: (() -> Void)?

  var navigationController: UINavigationController
  var searchResultViewController: SearchResultViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.searchResultViewController = SearchResultViewController()
  }
  
  override func start() {
    self.searchResultViewController.viewModel = SearchResultViewModel(coordinator: self,
                                                                        perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared))
    
//    self.searchResultViewController.hidesBottomBarWhenPushed = false
    self.navigationController.pushViewController(self.searchResultViewController, animated: true)
  }
  
}
