//
//  DefaultSurveyCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import UIKit

final class DefaultSurveyCoordinator: BaseCoordinator, SurveyCoordinator{
  
  var finishFlow: (() -> Void)?
  
  var surveyViewController: SurveyViewController
  
  override init(_ navigationController: UINavigationController) {
    self.surveyViewController = SurveyViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showSurverViewController()
  }
  
  private func showSurverViewController() {
    let userRepository = DefaultUserRepository(userService: DefaultUserService.shared,
                                               userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)

    self.surveyViewController.viewModel = SurveyViewModel(
      coordinator: self,
      perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared),
      userRepository: userRepository,
      keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService.shared)
    )
    self.navigationController.setViewControllers([self.surveyViewController], animated: true)
  }
}
