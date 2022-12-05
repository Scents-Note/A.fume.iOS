//
//  DefaultApplicationCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultApplicationCoordinator: BaseCoordinator, ApplicationCoordinator {
  
  override init(_ navigationController: UINavigationController) {
    super.init(navigationController)
    self.navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  override func start() {
    self.runSplashFlow()
//    self.runMainFlow()
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
    let onboardingCoordinator = DefaultOnboardingCoordinator(navigationController)
    onboardingCoordinator.finishFlow = { [unowned self, unowned onboardingCoordinator] type in
      self.removeDependency(onboardingCoordinator)
      self.navigationController.dismiss(animated: true)
      switch type {
      case .main:
        self.runMainFlow()
      case .survey:
        self.runSurveyFlow()
      default:
        break
      }
    }
    self.addDependency(onboardingCoordinator)
    onboardingCoordinator.start()
  }
  
  func runMainFlow() {
    let mainCoordinator = DefaultMainCoordinator(self.navigationController)
    mainCoordinator.onOnboardingFlow = {
      self.runOnboardingFlow()
    }
    self.addDependency(mainCoordinator)
    mainCoordinator.start()
  }
  
  func runSurveyFlow() {
    let surveyCoordinator = DefaultSurveyCoordinator(self.navigationController)
    surveyCoordinator.finishFlow = { [unowned self] in
      self.removeDependency(surveyCoordinator)
//      self.initialNavigationController()
      self.runMainFlow()
    }
    self.addDependency(surveyCoordinator)
    surveyCoordinator.start()

  }

}

extension DefaultApplicationCoordinator {
  func initialNavigationController() {
    self.navigationController.view.backgroundColor = .white
    self.navigationController.viewControllers.removeAll()
  }
}
