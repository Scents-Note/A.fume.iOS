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
  
  func checkDuplicateEmail(email: String, completion: @escaping (Result<Bool?, NetworkError>) -> Void) {
    requestObject(.checkDuplicateEmail(email: email), completion: completion)
  }
  
  func checkDuplicateNickname(nickname: String, completion: @escaping (Result<Bool?, NetworkError>) -> Void) {
    requestObject(.checkDuplicateNickname(nickname: nickname), completion: completion)
  }

}

