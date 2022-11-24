//
//  DefaultMainCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/04.
//

import UIKit

final class DefaultMainCoordinator: BaseCoordinator, MainCoordinator {
  
  var finishFlow: ((CoordinatorType) -> Void)?
  var onOnboardingFlow: (() -> Void)?
  
  var tabBarController: UITabBarController
  
  override init(_ navigationController: UINavigationController) {
    self.tabBarController = UITabBarController()
    super.init(navigationController)
  }
  
  override func start() {
    let pages: [TabBarPage] = TabBarPage.allCases
    let controllers: [UINavigationController] = pages.map({
      self.createTabNavigationController(of: $0)
    })
    self.configureTabBarController(with: controllers)
  }
  
  private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
    return UITabBarItem(
      title: nil,
      image: UIImage(named: page.tabIconName()),
      tag: page.pageOrderNumber()
    )
  }
  
  private func configureTabBarController(with tabViewControllers: [UIViewController]) {
    self.tabBarController.setViewControllers(tabViewControllers, animated: true)
    self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
    self.tabBarController.view.backgroundColor = .white
    self.tabBarController.tabBar.backgroundColor = .bgTabBar
    self.tabBarController.tabBar.tintColor = .blackText
    
    self.navigationController.pushViewController(self.tabBarController, animated: true)
  }
  
  private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
    let tabNavigationController = BaseNavigationController()
    
    tabNavigationController.setNavigationBarHidden(false, animated: false)
    tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
    self.startTabCoordinator(of: page, to: tabNavigationController)
    return tabNavigationController
  }
  
  private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
    switch page {
    case .home:
      let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
      self.addDependency(homeCoordinator)
      homeCoordinator.start()
    case .search:
      let searchCoordinator = DefaultSearchCoordinator(tabNavigationController)
      self.addDependency(searchCoordinator)
      searchCoordinator.start()
    case .mypage:
      let myPageCoordinator = DefaultMyPageCoordinator(tabNavigationController)
      myPageCoordinator.onOnboardingFlow = onOnboardingFlow
      self.addDependency(myPageCoordinator)
      myPageCoordinator.start()
    }
  }
  
  //  private func showOnboardingViewController() {
  //    self.onboardingViewController.viewModel = OnboardingViewModel(
  //      coordinator: self
  //    )
  //    self.navigationController.viewControllers = [self.onboardingViewController]
  //  }
}
