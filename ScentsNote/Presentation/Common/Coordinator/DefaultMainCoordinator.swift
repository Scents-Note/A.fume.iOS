//
//  DefaultMainCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/04.
//

import UIKit

final class DefaultMainCoordinator: BaseCoordinator, MainCoordinator {
  
  // MARK: Navigate
  var finishFlow: ((CoordinatorType) -> Void)?
  var runOnboardingFlow: (() -> Void)?
  
  // MARK: - ViewController
  var tabBarController: UITabBarController
  
  override init(_ navigationController: UINavigationController) {
    self.tabBarController = UITabBarController()
    super.init(navigationController)
  }
  
  override func start() {
    self.showTabBarController()
  }
  
  func showTabBarController() {
    let pages: [TabBarPage] = TabBarPage.allCases
    let controllers: [UINavigationController] = pages.map {
      self.setTabNavigationController(of: $0)
    }
    self.configureTabBarController(with: controllers)
  }
  
  private func configureTabBarController(with tabViewControllers: [UIViewController]) {
    self.tabBarController.setViewControllers(tabViewControllers, animated: false)
    self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
    self.tabBarController.view.backgroundColor = .bgTabBar
    self.tabBarController.tabBar.backgroundColor = .bgTabBar
    self.tabBarController.tabBar.tintColor = .blackText
    self.tabBarController.tabBar.isTranslucent = true
    self.navigationController.viewControllers = [self.tabBarController]
    self.navigationController.isNavigationBarHidden = true
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = .bgTabBar
      UITabBar.appearance().standardAppearance = appearance
      UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
  }
  
  private func setTabNavigationController(of page: TabBarPage) -> UINavigationController {
    let tabNavigationController = BaseNavigationController()
    tabNavigationController.setNavigationBarHidden(false, animated: false)
    tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
    self.startTabCoordinator(of: page, to: tabNavigationController)
    return tabNavigationController
  }
  
  private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
    return UITabBarItem(title: page.tabName(),
                        image: UIImage(named: page.tabIconUnselected()),
                        selectedImage: UIImage(named: page.tabIconSelected()))
  }
  
  private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
    switch page {
    case .home:
      let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
      self.addDependency(homeCoordinator)
      homeCoordinator.runOnboardingFlow = runOnboardingFlow
      homeCoordinator.start()
    case .search:
      let searchCoordinator = DefaultSearchCoordinator(tabNavigationController)
      self.addDependency(searchCoordinator)
      searchCoordinator.runOnboardingFlow = runOnboardingFlow
      searchCoordinator.start()
    case .mypage:
      let myPageCoordinator = DefaultMyPageCoordinator(tabNavigationController)
      self.addDependency(myPageCoordinator)
      myPageCoordinator.runOnboardingFlow = runOnboardingFlow
      myPageCoordinator.start()
    }
  }
}
