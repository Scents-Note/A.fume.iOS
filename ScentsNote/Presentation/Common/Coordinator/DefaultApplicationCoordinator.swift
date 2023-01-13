//
//  DefaultApplicationCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultApplicationCoordinator: BaseCoordinator, ApplicationCoordinator {
    
  // MARK: - Life Cycle
  override init(_ navigationController: UINavigationController) {
    super.init(navigationController)
    self.navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  func runSplashFlow() {
    let coordinator = DefaultSplashCoordinator(navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.removeDependency(coordinator)
      self.runMainFlow()
    }
    self.addDependency(coordinator)
    coordinator.start()
  }
  
  func runOnboardingFlow() {
    let coordinator = DefaultOnboardingCoordinator(navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] type in
      self.removeDependency(coordinator)
      switch type {
      case .main:
        self.runMainFlow()
      case .survey:
        self.runSurveyFlow()
      default:
        break
      }
    }
    self.addDependency(coordinator)
    coordinator.start()
  }
  
  func runMainFlow() {
    let coordinator = DefaultMainCoordinator(self.navigationController)
    coordinator.runOnboardingFlow = { [unowned self] in
      self.runOnboardingFlow()
    }
    self.addDependency(coordinator)
    coordinator.start()
  }
  
  func runSurveyFlow() {
    let coordinator = DefaultSurveyCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self] in
      self.removeDependency(coordinator)
      self.runMainFlow()
    }
    self.addDependency(coordinator)
    coordinator.start()
  }

}
