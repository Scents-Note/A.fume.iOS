//
//  DefaultSearchKeywordCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit

final class DefaultSearchKeywordCoordinator: BaseCoordinator, SearchKeywordCoordinator {
  
  var finishFlow: ((PerfumeSearch) -> Void)?
  
  var searchKeywordViewController: SearchKeywordViewController
  
  
  override init(_ navigationController: UINavigationController) {
    self.searchKeywordViewController = SearchKeywordViewController()
    super.init(navigationController)
  }
  
  override func start(from: CoordinatorType) {
    self.searchKeywordViewController.viewModel = SearchKeywordViewModel(coordinator: self,
                                                                        from: from)
    
    self.searchKeywordViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.searchKeywordViewController, animated: true)
  }
}
