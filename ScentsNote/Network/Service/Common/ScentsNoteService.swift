//
//  ScentsNoteService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//

import Foundation

import RxSwift
import Moya
import Alamofire
import Foundation


// TODO: 토큰관련 인터셉터 구현
fileprivate let provider: MoyaProvider<ScentsNoteAPI> = {
  let provider = MoyaProvider<ScentsNoteAPI>()
  return provider
}()

class ScentsNoteService {
  
  func requestObject<T: Decodable>(_ target: ScentsNoteAPI) -> Observable<T> {
    return provider.rx.request(target)
      .asObservable()
      .filterSuccessfulStatusCodes()
      .catch(self.handleInternetConnection)
        .catch(self.handleTimeOut)
        .catch(self.handleREST)
//        .retry(2)
//        .retry(when: retryHandler)
//        .take(3)
        .map { try JSONDecoder().decode(ResponseObject<T>.self, from: $0.data) }
      .compactMap { $0.data }
  }
  
  func requestPlainObject(_ target: ScentsNoteAPI) -> Observable<String> {
    return provider.rx.request(target)
      .asObservable()
      .filterSuccessfulStatusCodes()
      .catch(self.handleInternetConnection)
        .catch(self.handleTimeOut)
        .catch(self.handleREST)
//      .retry(when: retryHandler)
        .map { try JSONDecoder().decode(ResponsePlainObject.self, from: $0.data) }
      .compactMap { $0.message }
  }
  
  let retryHandler: (Observable<Error>) -> Observable<Int> = { error in
    return error.enumerated().flatMap { (attempt, error) -> Observable<Int> in
      if attempt >= 2 {
        return Observable.error(error)
      }
      UserDefaults.standard.removeObject(forKey: "token")
      let token = UserDefaults.standard.string(forKey: "token")
      Log(token)
      let email = UserDefaults.standard.string(forKey: "email")
      let password = UserDefaults.standard.string(forKey: "password")
      guard let email = email, let password = password else {
        return Observable.error(error)
      }
      
      DefaultUserService.shared.login(email: email, password: password)
        .subscribe(onNext: { loginInfo in
          Log(loginInfo)
        }, onError: { error in
          Log(error)
        })
        .disposed(by: DisposeBag())
      
//      provider.rx.request(.login(email: email, password: password))
//        .asObservable()
//        .map { try JSONDecoder().decode(ResponseObject<LoginInfo>.self, from: $0.data) }
//        .compactMap { $0.data }
//        .subscribe(onNext: { loginInfo in
//          Log(loginInfo)
////          UserDefaults.standard.set(loginInfo.token, forKey: "token")
//        }, onError: { error in
//          Log(error)
//        })
//        .disposed(by: DisposeBag())
////      DefaultUserService.shared.login(email: email, password: password)

      Log("123123123")

      return Observable.just(1)
    }
  }
}

// MARK: Handle Network Error
extension ScentsNoteService {
  func handleInternetConnection<T: Any>(error: Error) throws -> Observable<T> {
    guard
      let urlError = Self.converToURLError(error),
      Self.isNotConnection(error: error)
    else { throw error }
    throw NetworkError.internetConnection(urlError)
  }
  
  func handleTimeOut<T: Any>(error: Error) throws -> Observable<T> {
    guard
      let urlError = Self.converToURLError(error),
      urlError.code == .timedOut
    else { throw error }
    throw NetworkError.requestTimeout(urlError)
  }
  
  func handleREST<T: Any>(error: Error) throws -> Observable<T> {
    guard error is NetworkError else {
      let statusCode = (error as? MoyaError)?.response?.statusCode
      let description = (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?.first?.value as? String
//      if statusCode == 401 {
//        Log("ihihi")
//        let email = UserDefaults.standard.string(forKey: "email")
//        let password = UserDefaults.standard.string(forKey: "password")
//        DefaultUserService.shared.login(email: email!, password: password!)
//          .subscribe(onNext: { loginInfo in
//            Log(loginInfo)
//          }, onError: { error in
//            Log(error)
//          })
//          .disposed(by: DisposeBag())
//      }
      Log((error as? MoyaError)?.response)
      throw NetworkError.restError(statusCode: statusCode, description: description)
    }
    throw error
  }
}
