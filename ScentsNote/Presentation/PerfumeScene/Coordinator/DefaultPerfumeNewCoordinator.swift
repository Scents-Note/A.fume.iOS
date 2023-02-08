//
//  DefaultPerfumeNewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit

final class DefaultPerfumeNewCoordinator: BaseCoordinator, PerfumeNewCoordinator {
  
  var runOnboardingFlow: (() -> Void)?
  
  var runPerfumeDetailFlow: ((Int) -> Void)?

  var perfumeNewViewController: PerfumeNewViewController
  
  override init(_ navigationController: UINavigationController) {
    self.perfumeNewViewController = PerfumeNewViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.perfumeNewViewController.viewModel = PerfumeNewViewModel(
      coordinator: self,
      fetchPerfumesNewUseCase: DefaultFetchPerfumesNewUseCase(perfumeRepository: DefaultPerfumeRepository.shared),
      updatePerfumeLikeUseCase: DefaultUpdatePerfumeLikeUseCase(perfumeRepository: DefaultPerfumeRepository.shared)
    )
    self.perfumeNewViewController.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(self.perfumeNewViewController, animated: true)
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
  
  func showPopup() {
    let vc = LabelPopupViewController().then {
      $0.setButtonState(state: .two)
      $0.setLabel(content: "로그인 후 사용 가능합니다.\n로그인을 해주세요.")
      $0.setConfirmLabel(content: "로그인 하기")
    }
    vc.viewModel = LabelPopupViewModel(coordinator: self,
                                       delegate: self.perfumeNewViewController.viewModel!)
    
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    self.navigationController.present(vc, animated: false)
  }
  
  func hidePopup() {
    self.navigationController.dismiss(animated: false)
  }
  
}
