//
//  DefaultPerfumeReviewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit

final class DefaultPerfumeReviewCoordinator: BaseCoordinator, PerfumeReviewCoordinator {
  
  var finishFlow: (() -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  var perfumeReviewViewController: PerfumeReviewViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeReviewViewController = PerfumeReviewViewController()
    super.init(navigationController)
  }
  
  func start(perfumeDetail: PerfumeDetail) {
    self.perfumeReviewViewController.viewModel = PerfumeReviewViewModel(
      coordinator: self,
      perfumeDetail: perfumeDetail,
      addReviewUseCase: DefaultAddReviewUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
      fetchKeywordsUseCase: DefaultFetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository.shared)
    )
    self.perfumeReviewViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeReviewViewController, animated: true)
  }
  
  func start(reviewIdx: Int) {
    self.perfumeReviewViewController.viewModel = PerfumeReviewViewModel(
      coordinator: self,
      reviewIdx: reviewIdx,
      fetchReviewDetailUseCase: DefaultFetchReviewDetailUseCase(reviewRepository: DefaultReviewRepository.shared),
      updateReviewUseCase: DefaultUpdateReviewUseCase(reviewRepository: DefaultReviewRepository.shared),
      fetchKeywordsUseCase: DefaultFetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository.shared),
      deleteReviewUseCase: DefaultDeleteReviewUseCase(reviewRepository: DefaultReviewRepository.shared)
    )
    self.perfumeReviewViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeReviewViewController, animated: true)
  }
  
  func showKeywordBottomSheetViewController(keywords: [Keyword]) {
    let vc = KeywordBottomSheetViewController()
    vc.viewModel = KeywordBottomSheetViewModel(
      coordinator: self,
      delegate: self.perfumeReviewViewController.viewModel!,
      keywords: keywords
    )

    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hideKeywordBottomSheetViewController(keywords: [Keyword]) {
    
  }
  
  func showPopup() {
    let vc = LabelPopupViewController()
    vc.setLabel(content: "정말로 삭제하실 건가요?")
    vc.viewModel = LabelPopupViewModel(
      coordinator: self,
      delegate: self.perfumeReviewViewController.viewModel!
    )
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hidePopup() {
    self.navigationController.dismiss(animated: false)
  }
}
