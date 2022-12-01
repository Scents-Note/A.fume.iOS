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
  var onSignUpFlow: ((CoordinatorType) -> Void)?

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
    let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
    loginCoordinator.finishFlow = { [unowned self, unowned loginCoordinator] in
      self.removeDependency(loginCoordinator)
      self.navigationController.viewControllers.removeAll()
      self.navigationController.view.backgroundColor = .white
      self.finishFlow?(.main)
    }
    loginCoordinator.onSignUpFlow = {
      self.runSignUpFlow()
    }

    loginCoordinator.start()
    self.addDependency(loginCoordinator)
  }
  
  func runSignUpFlow() {
    let signupCoordinator = DefaultSignUpCoordinator(self.navigationController)
    signupCoordinator.finishFlow = { [unowned self] in
      self.finishFlow?(.survey)
    }
    self.childCoordinators.append(signupCoordinator)
    signupCoordinator.start()
  }
  
}

extension DefaultOnboardingCoordinator: OnSignUpCoordinatorDelegate {
  func onSignUpCoordinator() {
    self.runSignUpFlow()
  }
}
