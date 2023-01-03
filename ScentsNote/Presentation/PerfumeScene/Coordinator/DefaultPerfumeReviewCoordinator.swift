//
//  DefaultPerfumeReviewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit

final class DefaultPerfumeReviewCoordinator: BaseCoordinator, PerfumeReviewCoordinator {
  
  var finishFlow: (() -> Void)?
  var perfumeReviewViewController: PerfumeReviewViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeReviewViewController = PerfumeReviewViewController()
    super.init(navigationController)
  }
  
  func start(perfumeDetail: PerfumeDetail) {
    self.perfumeReviewViewController.viewModel = PerfumeReviewViewModel(
      coordinator: self,
      perfumeDetail: perfumeDetail,
      addReviewUseCase: AddReviewUseCase(perfumeRepository: DefaultPerfumeRepository(perfumeService: DefaultPerfumeService.shared)),
      fetchKeywordsUseCase: FetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService.shared))
    )
    self.navigationController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeReviewViewController, animated: true)
  }
  
  func start(reviewIdx: Int) {
    let reviewRepository = DefaultReviewRepository(reviewService: DefaultReviewService.shared)
    
    self.perfumeReviewViewController.viewModel = PerfumeReviewViewModel(
      coordinator: self,
      reviewIdx: reviewIdx,
      fetchReviewDetailUseCase: FetchReviewDetailUseCase(reviewRepository: reviewRepository),
      updateReviewUseCase: UpdateReviewUseCase(reviewRepository: reviewRepository),
      fetchKeywordsUseCase: FetchKeywordsUseCase(keywordRepository: DefaultKeywordRepository(keywordService: DefaultKeywordService.shared)),
      deleteReviewUseCase: DeleteReviewUseCase(reviewRepository: reviewRepository)
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
  
  func showDeletePopup() {
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
  
  func hideDeletePopup() {
    self.navigationController.dismiss(animated: false)
  }
}
