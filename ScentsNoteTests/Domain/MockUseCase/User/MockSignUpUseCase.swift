//
//  MockSignUpUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/19.
//

import RxSwift
@testable import ScentsNote

final class MockSignUpUseCase: SignUpUseCase {
  let loginInfo = LoginInfo.default
  func execute(signUpInfo: SignUpInfo) -> Observable<LoginInfo> {
    return Observable.create { [unowned self] observer in
      observer.onNext(self.loginInfo)
      return Disposables.create()
    }
  }
}
