//
//  DefaultApplicationCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

final class DefaultApplicationCoordinator: BaseCoordinator, ApplicationCoordinator {
  
  //  weak var finishDelegate: CoordinatorFinishDelegate?
  
  var navigationController: UINavigationController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  //  override var type: CoordinatorType? { .signUp }
  //  override var type: CoordinatorType? { .app }
  
  override func start() {
//    self.runOnboardingFlow()
    self.runSurveyFlow()
  }
  
  func runOnboardingFlow() {
    let onboardingCoordinator = DefaultOnboardingCoordinator(self.navigationController)
    onboardingCoordinator.finishFlow = { [unowned self, unowned onboardingCoordinator] type in
      self.removeDependency(onboardingCoordinator)
      self.navigationController.viewControllers.removeAll()
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
    
  }
  
  func runSurveyFlow() {
    let surveyCoordinator = DefaultSurveyCoordinator(self.navigationController)
    surveyCoordinator.finishFlow = { [unowned self] in
      self.runMainFlow()
    }
    self.addDependency(surveyCoordinator)
    surveyCoordinator.start()

  }
  
}

//extension DefaultApplicationCoordinator: CoordinatorFinishDelegate {
//  func coordinatorDidFinish(childCoordinator: Coordinator) {
//    self.removeDependency(childCoordinator)
//    self.navigationController.view.backgroundColor = .systemBackground
//    self.navigationController.viewControllers.removeAll()
//
//    switch childCoordinator.type {
//    case .onboarding:
//      self.runOnboardingFlow()
//    default:
//      break
//    }
//  }
//}
