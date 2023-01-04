//
//  SearchResultCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

protocol SearchResultCoordinator: PopUpCoordinator {
  
  var runOnboardingFlow: (() -> Void)? { get set }
  var runPerfumeDetailFlow: ((Int) -> Void)? { get set }
  var runSearchKeywordFlow: (() -> Void)? { get set }
  var runSearchFilterFlow: (() -> Void)? { get set }
  var finishFlow: (() -> Void)? { get set }
  
  func runWebFlow(with url: String)
}
