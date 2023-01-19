//
//  EditInfoCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import Foundation

protocol EditInformationCoordinator: BirthPopUpCoordinator {

  var finishFlow: (() -> Void)? { get set }
  func showWebViewController(with url: String)
}
