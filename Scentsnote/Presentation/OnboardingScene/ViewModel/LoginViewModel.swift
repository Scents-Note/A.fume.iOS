//
//  LoginViewModel.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import Foundation

final class LoginViewModel {
  private weak var coordinator: LoginCoordinator?

  init(coordinator: LoginCoordinator?) {
    self.coordinator = coordinator
  }
}
