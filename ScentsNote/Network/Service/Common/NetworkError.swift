//
//  Moya+NetworkError.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/09.
//


import Alamofire
import Moya

enum NetworkError: Error {
  case empty
  case requestTimeout(Error)
  case internetConnection(Error)
  case restError(statusCode: Int? = nil, description: String? = nil)
  
  var statusCode: Int? {
    switch self {
    case let .restError(statusCode, _):
      return statusCode
    default:
      return nil
    }
  }
  var errorCodes: [String] {
    switch self {
    case let .restError(_, errorCode):
      return [errorCode].compactMap { $0 }
    default:
      return []
    }
  }
  var isNoNetwork: Bool {
    switch self {
    case let .requestTimeout:
      fallthrough
    case let .restError(_, _):
      return true
    case .internetConnection:
      return true
    default:
      return false
    }
  }
}


extension ScentsNoteService {
  static func converToURLError(_ error: Error) -> URLError? {
    switch error {
    case let MoyaError.underlying(afError as AFError, _):
      fallthrough
    case let afError as AFError:
      return afError.underlyingError as? URLError
    case let MoyaError.underlying(urlError as URLError, _):
      fallthrough
    case let urlError as URLError:
      return urlError
    default:
      return nil
    }
  }
  
 static func isNotConnection(error: Error) -> Bool {
   return Self.converToURLError(error)?.code == .notConnectedToInternet
  }
  
  static func isLostConnection(error: Error) -> Bool {
    switch error {
    case let AFError.sessionTaskFailed(error: posixError as POSIXError)
      where posixError.code == .ECONNABORTED: // eConnAboarted: Software caused connection abort.
      break
    case let MoyaError.underlying(urlError as URLError, _):
      fallthrough
    case let urlError as URLError:
      guard urlError.code == URLError.networkConnectionLost else { fallthrough } // A client or server connection was severed in the middle of an in-progress load.
      break
    default:
      return false
    }
    return true
  }
}
