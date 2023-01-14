//
//  DefaultSearchFilterCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit

final class DefaultSearchFilterCoordinator: BaseCoordinator, SearchFilterCoordinator {
  
  var finishFlow: ((PerfumeSearch?) -> Void)?
  
  var searchFilterViewController: SearchFilterViewController
  
  override init(_ navigationController: UINavigationController) {
    self.searchFilterViewController = SearchFilterViewController()
    super.init(navigationController)
  }
  
  override func start(from: CoordinatorType) {
    self.searchFilterViewController.viewModel = SearchFilterViewModel(coordinator: self,
                                                                      fetchFilterBrandInitialUseCase: DefaultFetchFilterBrandInitialUseCase(filterRepository: DefaultFilterRepository.shared),
                                                                      fetchBrandsForFilterUseCase: DefaultFetchBrandsForFilterUseCase(filterRepository: DefaultFilterRepository.shared),
                                                                      fetchSeriesForFilterUseCase: DefaultFetchSeriesForFilterUseCase(filterRepository: DefaultFilterRepository.shared),
                                                                      fetchKeywordsUseCase: DefaultFetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository.shared),
                                                                      from: from)
      
    self.navigationController.present(self.searchFilterViewController, animated: true)
  }
}
