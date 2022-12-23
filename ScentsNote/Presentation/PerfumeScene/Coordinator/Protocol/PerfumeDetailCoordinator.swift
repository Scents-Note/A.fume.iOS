//
//  PerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import Foundation

protocol PerfumeDetailCoordinator: AnyObject {
  var runPerfumeReviewFlow: ((PerfumeDetail) -> Void)? { get set }
  var runPerfumeDetailFlow: ((Int) -> Void)? { get set }
  
  func showReviewReportPopupViewController(reviewIdx: Int)
  func hideReviewReportPopupViewController()
}
