//
//  DefaultSignCoordinator.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation
import UIKit

class DefaultOnboardingCoordinator: OnboardingCoordinator {
  
  weak var finishDelegate: CoordinatorFinishDelegate?
  var navigationController: UINavigationController
  var onboardingViewController: OnboardingViewController
  var childCoordinators = [Coordinator]()
  var type: CoordinatorType { .onboarding }
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.onboardingViewController = OnboardingViewController()
    //    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  func start() {
    self.onboardingViewController.viewModel = OnboardingViewModel(
      coordinator: self
    )
    self.navigationController.viewControllers = [self.onboardingViewController]
  }
  
  func runLoginFlow() {
    let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
    loginCoordinator.finishDelegate = self
    self.childCoordinators.append(loginCoordinator)
    loginCoordinator.showLoginViewController()
  }
  
  func runSignUpFlow() {
    
  }
  
  
}

extension DefaultOnboardingCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
