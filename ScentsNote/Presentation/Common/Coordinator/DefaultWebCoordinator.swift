//
//  DefaultWebCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit

final class DefaultWebCoordinator: BaseCoordinator, WebCoordinator {
  
  // MARK: - Navigate
  var finishFlow: (() -> Void)?
  
  // MARK: - ViewController
  var webViewController: WebViewController
  
  override init(_ navigationController: UINavigationController) {
    self.webViewController = WebViewController()
    super.init(navigationController)
  }
  
  func start(with url: String) {
    self.showWebController(url: url)
  }
  
  func showWebController(url: String) {
    let vc = self.webViewController
    vc.url = url
    vc.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(vc, animated: true)
  }
  
}
