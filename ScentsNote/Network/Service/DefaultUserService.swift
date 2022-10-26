//
//  DefaultUserService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/22.
//

import Foundation
import RxSwift
import Moya

final class DefaultUserService: ScentsNoteService, UserService {
  
  func login(email: String, password: String, completion: @escaping (Result<LoginInfo?, NetworkError>) -> Void) {
    requestObject(.login(email: email, password: password), completion: completion)
  }
}

