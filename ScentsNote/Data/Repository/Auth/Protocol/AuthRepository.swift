//
//  AuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation
import RxSwift

protocol AuthRepository {
  func login() -> Observable<Void>
}
