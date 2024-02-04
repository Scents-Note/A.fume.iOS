//
//  PerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import Foundation

protocol PerfumeDetailCoordinator: PopUpCoordinator {
  var finishFlow: (() -> Void)? { get set }
  var runOnboardingFlow: (() -> Void)? { get set }
  var runPerfumeReviewFlow: ((PerfumeDetail) -> Void)? { get set }
  var runPerfumeReviewFlowWithReviewIdx: ((Int) -> Void)? { get set }
  var runPerfumeDetailFlow: ((Int) -> Void)? { get set }
  
  func showPerfumeDetailViewController(perfumeIdx: Int)
  func runWebFlow(with url: String)
  func showReviewReportPopupViewController(reviewIdx: Int)
  func hideReviewReportPopupViewController()
  func hideReviewReportPopupViewController(hasToast: Bool)
  func showComparePriceViewController()
}
