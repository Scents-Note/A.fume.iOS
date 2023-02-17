//
//  Coordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/15.
//

import UIKit

protocol Coordinator: AnyObject {
  
  func start()
  func start(from: CoordinatorType)
  
}
