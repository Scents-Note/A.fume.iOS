//
//  DefaultMypageCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

final class DefaultMyPageCoordinator: BaseCoordinator, MyPageCoordinator {
  
  var onOnboardingFlow: (() -> Void)?

  var myPageViewController: MyPageViewController
  override init(_ navigationController: UINavigationController) {
    self.myPageViewController = MyPageViewController()
    super.init(navigationController)
  }
  
  override func start() {
    self.myPageViewController.viewModel = MyPageViewModel(
      coordinator: self,
      fetchPerfumesLikedUseCase: FetchPerfumesLikedUseCase(userRepository: DefaultUserRepository(userService: DefaultUserService.shared))
    )
    self.navigationController.pushViewController(self.myPageViewController, animated: true)
  }
  

}
