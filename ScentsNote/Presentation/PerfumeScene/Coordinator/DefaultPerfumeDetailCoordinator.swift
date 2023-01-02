//
//  DefaultPerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit

final class DefaultPerfumeDetailCoordinator: BaseCoordinator, PerfumeDetailCoordinator {

  var finishFlow: (() -> Void)?
  var runPerfumeReviewFlow: ((PerfumeDetail) -> Void)?
  var runPerfumeReviewFlowWithReviewIdx: ((Int) -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  override init(_ navigationController: UINavigationController) {
    
    super.init(navigationController)
  }
  
  func start(perfumeIdx: Int) {
    let perfumeDetailViewController = PerfumeDetailViewController()
    perfumeDetailViewController.viewModel = PerfumeDetailViewModel(
      coordinator: self,
      fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      updateReviewLikeUseCase: UpdateReviewLikeUseCase(reviewRepository: DefaultReviewRepository(reviewService: DefaultReviewService.shared)),
      perfumeIdx: perfumeIdx
    )
    perfumeDetailViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(perfumeDetailViewController, animated: true)
  }
  
  func runWebFlow(with url: String) {
    let coordinator = DefaultWebCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(with: url)
    self.addDependency(coordinator)
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
