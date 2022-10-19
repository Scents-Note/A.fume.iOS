//
//  SignUpViewModel.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/18.
//

import Foundation

final class SignUpViewModel {
  private weak var coordinator: SignUpCoordinator?
  
  init(coordinator: SignUpCoordinator?) {
    self.coordinator = coordinator
  }
}
