//
//  DefaultPerfumeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import UIKit

final class DefaultPerfumeDetailCoordinator: BaseCoordinator, PerfumeDetailCoordinator {
  
  // MARK: - Navigate
  var finishFlow: (() -> Void)?
  var runOnboardingFlow: (() -> Void)?
  var runPerfumeReviewFlow: ((PerfumeDetail) -> Void)?
  var runPerfumeReviewFlowWithReviewIdx: ((Int) -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  
  // MARK: - ViewController
  private let perfumeDetailViewController: PerfumeDetailViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeDetailViewController = PerfumeDetailViewController()
    super.init(navigationController)
  }
  
  func start(perfumeIdx: Int) {
    self.showPerfumeDetailViewController(perfumeIdx: perfumeIdx)
  }
  
  func showPerfumeDetailViewController(perfumeIdx: Int) {
    self.perfumeDetailViewController.viewModel = PerfumeDetailViewModel(coordinator: self,
                                                                        fetchPerfumeDetailUseCase: DefaultFetchPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                                        fetchReviewsInPerfumeDetailUseCase: DefaultFetchReviewsInPerfumeDetailUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                                        updatePerfumeLikeUseCase: DefaultUpdatePerfumeLikeUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
                                                                        updateReviewLikeUseCase: DefaultUpdateReviewLikeUseCase(reviewRepository: DefaultReviewRepository.shared),
                                                                        fetchUserDefaultUseCase: DefaultFetchUserDefaultUseCase(userRepository: DefaultUserRepository.shared),
                                                                        perfumeIdx: perfumeIdx
    )
    self.perfumeDetailViewController.hidesBottomBarWhenPushed = true
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
                                              reportReviewUseCase: DefaultReportReviewUseCase(reviewRepository: DefaultReviewRepository.shared),
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
    
    func showComparePriceViewController() {
        let vc = PerfumeComparePriceViewController()
        self.navigationController.present(vc, animated: true)
    }
  
  func showPopup() {
    let vc = LabelPopupViewController().then {
      $0.setButtonState(state: .two)
      $0.setLabel(content: "로그인 후 사용 가능합니다.\n로그인을 해주세요.")
      $0.setConfirmLabel(content: "로그인 하기")
    }
    vc.viewModel = LabelPopupViewModel(coordinator: self,
                                       delegate: self.perfumeDetailViewController.viewModel!)
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hidePopup() {
    self.navigationController.dismiss(animated: false)
  }
}
