//
//  DefaultMainCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/04.
//

import UIKit

final class DefaultMainCoordinator: BaseCoordinator, MainCoordinator {
  
  var finishFlow: ((CoordinatorType) -> Void)?

  var navigationController: UINavigationController
  var onboardingViewController: OnboardingViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.onboardingViewController = OnboardingViewController()
    //    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  override func start() {
//    self.showOnboardingViewController()
  }
  
//  private func showOnboardingViewController() {
//    self.onboardingViewController.viewModel = OnboardingViewModel(
//      coordinator: self
//    )
//    self.navigationController.viewControllers = [self.onboardingViewController]
//  }
}
