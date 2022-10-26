//
//  DefaultAuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import RxSwift
import Moya

final class DefaultUserRepository: UserRepository {
  private let userService: UserService
  
  init(userService: UserService){
    self.userService = userService
  }
  
  func login(email: String, password: String, completion: @escaping (Result<LoginInfo?, NetworkError>) -> Void) {
    return self.userService.login(email: email, password: password, completion: completion)
  }
}

