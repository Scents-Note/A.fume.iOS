//
//  DefaultSearchCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultSearchCoordinator: BaseCoordinator, SearchCoordinator {
  var navigationController: UINavigationController
  var searchViewController: SearchViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.searchViewController = SearchViewController()
  }
  
  override func start() {
    self.searchViewController.viewModel = SearchViewModel(
      coordinator: self
    )
    self.navigationController.pushViewController(self.searchViewController, animated: true)
  }
}
