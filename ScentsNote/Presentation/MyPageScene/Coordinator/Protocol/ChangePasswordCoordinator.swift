//
//  ChangePasswordCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import Foundation

protocol ChangePasswordCoordinator: AnyObject {

  var finishFlow: (() -> Void)? { get set }
  
}
