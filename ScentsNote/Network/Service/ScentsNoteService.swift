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
  
  static let `default` = ScentsNoteService()
  
  //FIXME Observable로 바꿔보기
  func requestObject<T: Decodable>(_ target: ScentsNoteAPI, completion: @escaping (Result<T?, NetworkError>) -> Void) {
    provider.request(target) { response in
      switch response {
      case let .success(value):
        do {
          print("User Log: gg")
          let decoder = JSONDecoder()
          let body = try decoder.decode(ResponseObject<T>.self, from: value.data)
          completion(.success(body.data))
        } catch {
          print(error.localizedDescription)
          completion(.failure(.decodingError))
        }
      case let .failure(error):
        if let body = error.response?.data,
           let statusCode = error.response?.statusCode {
          do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let errorBody = try decoder.decode(ErrorBody.self, from: body)
            print("User Log: \(statusCode)")
            print("User Log: errorMsg \(errorBody.message ?? "no msg")")
            if let networkError = NetworkError.build(with: statusCode) {
              completion(.failure(networkError))
            } else {
              completion(.failure(.decodingError))
            }
          } catch {
            completion(.failure(.decodingError))
          }
        } else {
          completion(.failure(.decodingError))
        }
      }
    }
  }
}
