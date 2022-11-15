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

  var navigationController: UINavigationController
  var onboardingViewController: OnboardingViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.onboardingViewController = OnboardingViewController()
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
//    signupCoordinator.finishDelegate = self
    signupCoordinator.finishFlow = { [unowned self] in
//      self.navigationController.viewControllers.removeAll()
//      self.navigationController.view.backgroundColor = .white
      self.finishFlow?(.survey)
    }
    self.childCoordinators.append(signupCoordinator)
    signupCoordinator.start()
  }
  
}

//extension DefaultOnboardingCoordinator: CoordinatorFinishDelegate {
//  func coordinatorDidFinish(childCoordinator: Coordinator) {
//    self.removeDependency(childCoordinator)
////    self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
//  }
//}

extension DefaultOnboardingCoordinator: OnSignUpCoordinatorDelegate {
  func onSignUpCoordinator() {
    self.runSignUpFlow()
  }
}
