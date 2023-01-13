//
//  ApplicationCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

protocol ApplicationCoordinator {
  func runSplashFlow()
  func runOnboardingFlow()
  func runMainFlow()
  func runSurveyFlow()
}
