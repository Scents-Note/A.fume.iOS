//
//  DefaultSignCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation
import UIKit

class DefaultOnboardingCoordinator: BaseCoordinator, OnboardingCoordinator {
  
  var finishFlow: ((CoordinatorType) -> Void)?
  var onSignUpFlow: ((CoordinatorType) -> Void)?

//  weak var finishDelegate: CoordinatorFinishDelegate?
  var navigationController: UINavigationController
  var onboardingViewController: OnboardingViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.onboardingViewController = OnboardingViewController()
    //    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  override func start() {
    self.onboardingViewController.viewModel = OnboardingViewModel(
      coordinator: self
    )
    self.navigationController.viewControllers = [self.onboardingViewController]
  }
  
  func runLoginFlow() {
    let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
    loginCoordinator.finishFlow = { [unowned self, unowned loginCoordinator] in
      self.removeDependency(loginCoordinator)
      self.navigationController.viewControllers.removeAll()
      self.finishFlow?(.main)
    }
    loginCoordinator.onSignUpFlow = {
      self.runSignUpFlow()
    }
//    loginCoordinator.finishDelegate = self
//    loginCoordinator.onSignUpDelegate = self
    loginCoordinator.start()
    self.addDependency(loginCoordinator)
  }
  
  func runSignUpFlow() {
    let signupCoordinator = DefaultSignUpCoordinator(self.navigationController)
//    signupCoordinator.finishDelegate = self
    signupCoordinator.onSurveyFlow = { [unowned self] in
      self.navigationController.viewControllers.removeAll()
      self.finishFlow?(.survey)
    }
    self.childCoordinators.append(signupCoordinator)
    signupCoordinator.showSignUpInformationViewController()
  }
  
}

extension DefaultOnboardingCoordinator: CoordinatorFinishDelegate {
  func coordinatorDidFinish(childCoordinator: Coordinator) {
    self.removeDependency(childCoordinator)
//    self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}

extension DefaultOnboardingCoordinator: OnSignUpCoordinatorDelegate {
  func onSignUpCoordinator() {
    self.runSignUpFlow()
  }
}
