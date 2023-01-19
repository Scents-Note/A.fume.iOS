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
    self.surveyViewController.viewModel = SurveyViewModel(coordinator: self,
                                                          fetchPerfumesInSurveyUseCase: DefaultFetchPerfumesInSurveyUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                          fetchKeywordsUseCase: DefaultFetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository.shared),
                                                          fetchSeriesUseCase: DefaultFetchSeriesUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                          registerSurveyUseCase: DefaultRegisterSurveyUseCase(userRepository: DefaultUserRepository.shared))
    self.navigationController.setViewControllers([self.surveyViewController], animated: true)
  }
}
