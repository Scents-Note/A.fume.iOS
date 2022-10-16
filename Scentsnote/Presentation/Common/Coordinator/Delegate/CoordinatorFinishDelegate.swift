//
//  CoordinatorFinishDelegate.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/15.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
