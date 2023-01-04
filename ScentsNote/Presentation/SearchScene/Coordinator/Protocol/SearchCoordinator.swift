//
//  SearchCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

protocol SearchCoordinator: PopUpCoordinator {
  
  var runOnboardingFlow: (() -> Void)? { get set }
  func runPerfumeDetailFlow(perfumeIdx: Int)
  func runSearchKeywordFlow(from: CoordinatorType)
  func runSearchResultFlow(perfumeSearch: PerfumeSearch)
  func runSearchFilterFlow(from: CoordinatorType)
}
