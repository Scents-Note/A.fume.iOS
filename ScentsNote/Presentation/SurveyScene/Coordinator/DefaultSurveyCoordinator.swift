//
//  DefaultSurveyCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import UIKit

final class DefaultSurveyCoordinator: BaseCoordinator, SurveyCoordinator{
  
  var finishFlow: (() -> Void)?
  
  var navigationController: UINavigationController
  var surveyViewController: SurveyViewController
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.surveyViewController = SurveyViewController()
  }
  
  override func start() {
    self.showSurverViewController()
  }
  
  private func showSurverViewController() {
    self.surveyViewController.viewModel = SurveyViewModel(
      coordinator: self,
      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService()),
      userRepository: DefaultUserRepository(userService: DefaultUserService())
    )
    self.navigationController.setViewControllers([self.surveyViewController], animated: true)
  }
}
