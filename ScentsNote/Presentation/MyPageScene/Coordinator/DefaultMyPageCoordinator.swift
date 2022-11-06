//
//  DefaultMypageCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultMyPageCoordinator: BaseCoordinator, MyPageCoordinator {
  var navigationController: UINavigationController
  var myPageViewController: MyPageViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.myPageViewController = MyPageViewController()
  }
  
  override func start() {
    self.myPageViewController.viewModel = MyPageViewModel(
      coordinator: self
    )
    self.navigationController.pushViewController(self.myPageViewController, animated: true)
  }
}
