//
//  UserService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//

import Foundation
import RxSwift
import Moya

protocol UserService {
  func login(email: String, password: String, completion: @escaping (Result<LoginInfo?, NetworkError>) -> Void)
}
