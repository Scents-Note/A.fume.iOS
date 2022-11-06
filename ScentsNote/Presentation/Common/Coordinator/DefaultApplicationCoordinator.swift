//
//  DefaultApplicationCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultApplicationCoordinator: BaseCoordinator, ApplicationCoordinator {
  
  var navigationController: UINavigationController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  override func start() {
    self.runMainFlow()
//    self.runOnboardingFlow()
//    self.runSurveyFlow()
  }
  
  func runOnboardingFlow() {
    let onboardingCoordinator = DefaultOnboardingCoordinator(self.navigationController)
    onboardingCoordinator.finishFlow = { [unowned self, unowned onboardingCoordinator] type in
      self.removeDependency(onboardingCoordinator)
      self.navigationController.dismiss(animated: true)

      self.initialNavigationController()
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
