//
//  DefaultSearchCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultSearchCoordinator: BaseCoordinator, SearchCoordinator {
  
  var runOnboardingFlow: (() -> Void)?
  var runPerfumeDetailFlow: ((Int) -> Void)?
  var searchViewController: SearchViewController
  
  override init(_ navigationController: UINavigationController) {
    self.searchViewController = SearchViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.searchViewController.viewModel = SearchViewModel(
      coordinator: self,
      fetchPerfumesNewUseCase: DefaultFetchPerfumesNewUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
      updatePerfumeLikeUseCase: DefaultUpdatePerfumeLikeUseCase(perfumeRepository: DefaultPerfumeRepository.shared)
    )
    self.navigationController.pushViewController(self.searchViewController, animated: true)
  }

  
  func runPerfumeDetailFlow(perfumeIdx: Int) {
    let coordinator = DefaultPerfumeDetailCoordinator(self.navigationController)
    coordinator.runOnboardingFlow = runOnboardingFlow
    coordinator.runPerfumeDetailFlow = { [unowned self] perfumeIdx in
      self.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.runPerfumeReviewFlow = { [unowned self] perfumeDetail in
      self.runPerfumeReviewFlow(perfumeDetail: perfumeDetail)
    }
    coordinator.runPerfumeReviewFlowWithReviewIdx = { [unowned self] reviewIdx in
      self.runPerfumeReviewFlow(reviewIdx: reviewIdx)
    }
    coordinator.start(perfumeIdx: perfumeIdx)
    self.addDependency(coordinator)
  }
  
  func runPerfumeReviewFlow(perfumeDetail: PerfumeDetail) {
    let coordinator = DefaultPerfumeReviewCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(perfumeDetail: perfumeDetail)
    self.addDependency(coordinator)
  }
  
  func runPerfumeReviewFlow(reviewIdx: Int) {
    let coordinator = DefaultPerfumeReviewCoordinator(self.navigationController)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.navigationController.popViewController(animated: true)
      self.removeDependency(coordinator)
    }
    coordinator.start(reviewIdx: reviewIdx)
    self.addDependency(coordinator)
  }
  
  func runSearchKeywordFlow(from: CoordinatorType) {
    let coordinator = DefaultSearchKeywordCoordinator(self.navigationController)
    coordinator.finishFlow = { [weak self, unowned coordinator] perfumeSearch in
      switch from {
      case .search:
        self?.runSearchResultFlow(perfumeSearch: perfumeSearch)
      case .searchResult:
        self?.navigationController.popViewController(animated: true)
        let vc = self?.findViewController(SearchResultViewController.self) as! SearchResultViewController
        vc.viewModel?.updateSearchWords(perfumeSearch: perfumeSearch)
      default:
        break
      }
      self?.removeDependency(coordinator)
    }
    coordinator.start(from: from)
    self.addDependency(coordinator)
  }
  
  func runSearchFilterFlow(from: CoordinatorType) {
    let coordinator = DefaultSearchFilterCoordinator(self.navigationController)
    coordinator.finishFlow = { [weak self, unowned coordinator] perfumeSearch in
      self?.removeDependency(coordinator)
      self?.navigationController.dismiss(animated: true)
      guard let perfumeSearch = perfumeSearch else {
        return
      }
      switch from {
      case .search:
        self?.runSearchResultFlow(perfumeSearch: perfumeSearch)
      case .searchResult:
//        self?.navigationController.dismiss(animated: true)
        let vc = self?.findViewController(SearchResultViewController.self) as! SearchResultViewController
        vc.viewModel?.updateSearchWords(perfumeSearch: perfumeSearch)
      default:
        break
      }
    }
    coordinator.start(from: from)
    self.addDependency(coordinator)
  }
  
  func runSearchResultFlow(perfumeSearch: PerfumeSearch) {
    let coordinator = DefaultSearchResultCoordinator(self.navigationController)
    coordinator.runOnboardingFlow = runOnboardingFlow
    coordinator.runPerfumeDetailFlow = { [weak self] perfumeIdx in
      self?.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
    }
    coordinator.runSearchKeywordFlow = { [weak self] in
      self?.runSearchKeywordFlow(from: .searchResult)
    }
    coordinator.runSearchFilterFlow = { [weak self] in
      self?.runSearchFilterFlow(from: .searchResult)
    }
    coordinator.finishFlow = {
      
    }
    coordinator.start(perfumeSearch: perfumeSearch)
    self.addDependency(coordinator)
  }
  
  func showPopup() {
    let vc = LabelPopupViewController().then {
      $0.setLabel(content: "로그인 후 사용 가능합니다.\n로그인을 해주세요.")
      $0.setConfirmLabel(content: "로그인 하기")
    }
    vc.viewModel = LabelPopupViewModel(
      coordinator: self,
      delegate: self.searchViewController.viewModel!
    )
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hidePopup() {
    self.navigationController.dismiss(animated: false)
  }
}
