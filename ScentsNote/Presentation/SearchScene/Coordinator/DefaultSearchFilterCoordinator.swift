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
    let filterRepository = DefaultFilterRepository(filterService: DefaultFilterService.shared)
    self.searchFilterViewController.viewModel = SearchFilterViewModel(coordinator: self,
                                                                      fetchFilterBrandInitialUseCase: FetchFilterBrandInitialUseCase(filterRepository: filterRepository),
                                                                      fetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase(filterRepository: filterRepository),
                                                                      fetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase(filterRepository: filterRepository),
                                                                      fetchKeywordsUseCase: FetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService.shared)),
                                                                      from: from)
      
    self.navigationController.present(self.searchFilterViewController, animated: true)
  }
}
