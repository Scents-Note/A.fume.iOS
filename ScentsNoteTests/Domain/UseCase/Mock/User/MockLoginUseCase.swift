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
  
  var state: ResponseState? = .success
  var error: Error = NetworkError.restError(statusCode: 403, description: "이메일 또는 비밀번호가 잘못되었습니다")
  
  var excuteCalledCount = 0
  let loginInfo = LoginInfo(userIdx: 6, nickname: "득연", gender: "MAN", birth: 1995, token: "token", refreshToken: "refreshToken")
  
  let failureLoginInfo =  LoginInfo(userIdx: -1, token: "", refreshToken: "")
  
  func setState(state: ResponseState) {
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
    self.excuteCalledCount += 1
    if state == .success {
      return Observable.create { [unowned self] observer in
        observer.onNext(self.loginInfo)
        return Disposables.create()
      }
    } else {
      return Observable.create { [unowned self] observer in
        observer.onNext(self.failureLoginInfo)
        return Disposables.create()
      }
    }
  }
  
}
