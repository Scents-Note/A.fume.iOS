//
//  WebCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

protocol WebCoordinator {
  var finishFlow: (() -> Void)? { get set }
  func showWebController(url: String)
}
