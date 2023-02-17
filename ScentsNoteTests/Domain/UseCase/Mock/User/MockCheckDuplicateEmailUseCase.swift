//
//  MockCheckDuplicateEmailUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/19.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockCheckDuplicateEmailUseCase: CheckDuplicateEmailUseCase {
  
  var state: ResponseState? = .success
  var error: Error = NetworkError.restError(statusCode: 403, description: "")
  
  func setState(state: ResponseState) {
    self.state = state
  }
  
  func execute(email: String) -> Observable<Bool> {
    if state == .success {
      return Observable.create { observer in
        observer.onNext(true)
        return Disposables.create()
      }
    } else {
      return Observable.create { [unowned self] observer in
        observer.onError(self.error)
        return Disposables.create()
      }
    }
  }
}
