//
//  MockCheckIsSupportableVersionUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/17.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockCheckIsSupportableVersionUseCase: CheckIsSupportableVersionUseCase {
  func excute() -> Observable<Bool> {
    Observable.just(true)
  }
}
