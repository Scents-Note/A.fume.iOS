//
//  DefaultHomeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultHomeCoordinator: BaseCoordinator, HomeCoordinator {
  var navigationController: UINavigationController
  var homeViewController: HomeViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.homeViewController = HomeViewController()
  }
  
  override func start() {
    self.homeViewController.viewModel = HomeViewModel(
      coordinator: self
    )
    self.navigationController.pushViewController(self.homeViewController, animated: true)
  }
}
