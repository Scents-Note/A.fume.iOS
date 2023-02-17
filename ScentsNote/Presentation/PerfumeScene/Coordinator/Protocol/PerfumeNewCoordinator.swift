//
//  PerfumeNewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import Foundation

protocol PerfumeNewCoordinator: PopUpCoordinator {
  var runPerfumeDetailFlow: ((Int) -> Void)? { get set }
  var runOnboardingFlow: (() -> Void)? { get set }
  func runWebFlow(with url: String)
}
