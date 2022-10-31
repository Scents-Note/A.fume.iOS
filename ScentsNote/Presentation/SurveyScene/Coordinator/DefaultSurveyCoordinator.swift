//
//  DefaultSurveyCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import UIKit

final class DefaultSurveyCoordinator: BaseCoordinator, SurveyCoordinator{
  

//  weak var finishDelegate: CoordinatorFinishDelegate?
  
  var navigationController: UINavigationController
  var surveyViewController: SurveyViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.surveyViewController = SurveyViewController()
  }
  
  func showSurvetViewController() {
      self.surveyViewController.viewModel = SurveyViewModel(
          coordinator: self,
          userRepository: DefaultUserRepository(userService: DefaultUserService())
      )
      self.navigationController.pushViewController(self.surveyViewController, animated: true)
  }
  

  func finish() {
//    self.loginFinishDelegate?.loginCoordinatorDidFinish()
  }
  
}

