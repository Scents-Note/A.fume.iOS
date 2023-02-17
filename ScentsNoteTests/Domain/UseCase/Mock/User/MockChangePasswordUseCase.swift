//
//  MockChangePasswordUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockChangePasswordUseCase: ChangePasswordUseCase {
  func execute(password: Password) -> Observable<String> {
    
    let description = "비밀번호가 변경되었습니다."
    
    return Observable.create { observer in
      observer.onNext(description)
      return Disposables.create()
    }
  }
}
