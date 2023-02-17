//
//  MypageCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

protocol MyPageCoordinator: AnyObject {

  var runOnboardingFlow: (() -> Void)? { get set }
  
  func runPerfumeReviewFlow(reviewIdx: Int)
  func runPerfumeReviewFlow(perfumeDetail: PerfumeDetail)
  func runPerfumeDetailFlow(perfumeIdx: Int)
  func runEditInfoFlow()
  func runChangePasswordFlow()
  func runWebFlow(with url: String)
  func showMyPageMenuViewController()
  func hideMyPageMenuViewController()
}

