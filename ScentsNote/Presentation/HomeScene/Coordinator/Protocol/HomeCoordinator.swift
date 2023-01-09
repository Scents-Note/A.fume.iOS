//
//  HomeCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import Foundation

protocol HomeCoordinator: PopUpCoordinator {
  var runOnboardingFlow: (() -> Void)? { get set }
  
  func runPerfumeDetailFlow(perfumeIdx: Int)
  func runPerfumeNewFlow()
}
