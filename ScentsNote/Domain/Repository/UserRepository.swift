//
//  AuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation
import RxSwift
import Moya

protocol UserRepository {
  func login(email: String, password: String, completion: @escaping (Result<LoginInfo?, NetworkError>) -> Void)
  func checkDuplicateEmail(email: String, completion: @escaping (Result<Bool?, NetworkError>) -> Void)
  func checkDuplicateNickname(nickname: String, completion: @escaping (Result<Bool?, NetworkError>) -> Void)
}

