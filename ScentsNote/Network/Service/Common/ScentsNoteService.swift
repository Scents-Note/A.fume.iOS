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
        .map { try JSONDecoder().decode(ResponsePlainObject.self, from: $0.data) }
      .compactMap { $0.message }

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
      Log((error as? MoyaError)?.response)
      throw NetworkError.restError(statusCode: statusCode, description: description)
    }
    throw error
  }
}
