//
//  DefaultSignCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation
import UIKit

final class DefaultOnboardingCoordinator: BaseCoordinator, OnboardingCoordinator {
  
  var finishFlow: ((CoordinatorType) -> Void)?

  var onboardingViewController: OnboardingViewController
  
  override init(_ navigationController: UINavigationController) {
    self.onboardingViewController = OnboardingViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showOnboardingViewController()
  }
  
  private func showOnboardingViewController() {
    self.onboardingViewController.viewModel = OnboardingViewModel(
      coordinator: self
    )
    self.navigationController.pushViewController(self.onboardingViewController, animated: true)
  }
  
  func runLoginFlow() {
    let coordinator = DefaultLoginCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.removeDependency(coordinator)
      self.navigationController.viewControllers.removeAll()
      self.navigationController.view.backgroundColor = .white
      self.finishFlow?(.main)
    }
    coordinator.runSignUpFlow = {
      self.runSignUpFlow()
    }

    coordinator.start()
    self.addDependency(coordinator)
  }
  
  func runSignUpFlow() {
    let coordinator = DefaultSignUpCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.removeDependency(coordinator)
      self.finishFlow?(.survey)
    }
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }
}
