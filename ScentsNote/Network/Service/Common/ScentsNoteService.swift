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

fileprivate let provider: MoyaProvider<ScentsNoteAPI> = {
  let provider = MoyaProvider<ScentsNoteAPI>(endpointClosure: endpointClosure, session: DefaultAlamofireManager.shared)
  return provider
}()

fileprivate let endpointClosure = { (target: ScentsNoteAPI) -> Endpoint in
  let url = target.baseURL.appendingPathComponent(target.path).absoluteString
  var endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
  return endpoint
}

fileprivate class DefaultAlamofireManager: Alamofire.Session {
  static let shared: DefaultAlamofireManager = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return DefaultAlamofireManager(configuration: configuration)
  }()
}

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
