//
//  Coordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/15.
//

import UIKit

protocol Coordinator: AnyObject {
  
  func start()
  func start(type: CoordinatorType?)
  
}


//protocol Coordinator: AnyObject {
//  var finishDelegate: CoordinatorFinishDelegate? { get set }
//  var navigationController: UINavigationController { get set }
//  var childCoordinators: [Coordinator] { get set }
//  var type: CoordinatorType { get }
//  func start()
//  func finish()
//
//  init(_ navigationController: UINavigationController)
//}
//
//extension Coordinator {
//  func finish() {
//    childCoordinators.removeAll()
//    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
//  }
//}
