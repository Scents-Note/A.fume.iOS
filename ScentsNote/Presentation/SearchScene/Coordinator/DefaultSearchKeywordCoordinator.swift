//
//  DefaultSearchKeywordCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit

final class DefaultSearchKeywordCoordinator: BaseCoordinator, SearchKeywordCoordinator {

  var finishFlow: ((PerfumeSearch) -> Void)?

  var navigationController: UINavigationController
  var searchKeywordViewController: SearchKeywordViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.searchKeywordViewController = SearchKeywordViewController()
  }
  
  override func start() {
    self.searchKeywordViewController.viewModel = SearchKeywordViewModel(coordinator: self,
                                                                        perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared))
    
    self.searchKeywordViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.searchKeywordViewController, animated: true)
  }
  
}
