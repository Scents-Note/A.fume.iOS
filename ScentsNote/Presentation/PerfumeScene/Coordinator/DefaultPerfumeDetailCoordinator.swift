//
//  DefaultPerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit

final class DefaultPerfumeDetailCoordinator: BaseCoordinator, PerfumeDetailCoordinator {

  var runPerfumeReviewFlow: ((PerfumeDetail) -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  var perfumeDetailViewController: PerfumeDetailViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeDetailViewController = PerfumeDetailViewController()
    super.init(navigationController)
  }
  
  func start(perfumeIdx: Int) {
    
    self.perfumeDetailViewController.viewModel = PerfumeDetailViewModel(
      coordinator: self,
      fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      perfumeIdx: perfumeIdx
    )
    perfumeDetailViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeDetailViewController, animated: true)
  }
  
  func showReviewReportPopupViewController(reviewIdx: Int) {
    let vc = ReviewReportPopupViewController()
    vc.viewModel = ReviewReportPopupViewModel(coordinator: self,
                                              reportReviewUseCase: ReportReviewUseCase(reviewRepository: DefaultReviewRepository(reviewService: DefaultReviewService.shared)),
                                              reviewIdx: reviewIdx)
    vc.modalPresentationStyle = .overFullScreen
    self.navigationController.present(vc, animated: false, completion: nil)
  }
  
  func hideReviewReportPopupViewController() {
    self.hideReviewReportPopupViewController(hasToast: false)
  }
  
  func hideReviewReportPopupViewController(hasToast: Bool) {
    self.navigationController.dismiss(animated: false)
    if hasToast {
      guard let pvc = self.navigationController.viewControllers.last as? PerfumeDetailViewController else {
        return
      }
      pvc.viewModel?.showToast()
    }
  }

}
