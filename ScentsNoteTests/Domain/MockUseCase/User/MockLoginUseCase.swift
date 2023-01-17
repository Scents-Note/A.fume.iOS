//
//  MockLoginUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/16.
//

import RxSwift
@testable import ScentsNote

final class MockLoginUseCase: LoginUseCase {
  
  deinit { Log("MockLoginUseCase deinit")}
  
  enum ResponseState {
    case success
    case failure
  }
  
  let state: ResponseState
  var error: Error = NetworkError.restError(statusCode: 403, description: "이메일 또는 비밀번호가 잘못되었습니다")
  let loginInfo = LoginInfo(userIdx: 0, nickname: "testemr", gender: "MAN", birth: 1995, token: "", refreshToken: "")
  
  init(state: ResponseState) {
    self.state = state
  }
  
  func execute(email: String, password: String) -> Observable<LoginInfo> {
    if state == .success {
      return Observable.create { [unowned self] observer in
        observer.onNext(self.loginInfo)
        return Disposables.create()
      }
    } else {
      return Observable.create { [unowned self] observer in
        observer.onError(self.error)
        return Disposables.create()
      }
    }
    
  }
  
  func execute() -> Observable<LoginInfo> {
    if state == .success {
      return Observable.create { [unowned self] observer in
        observer.onNext(self.loginInfo)
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
