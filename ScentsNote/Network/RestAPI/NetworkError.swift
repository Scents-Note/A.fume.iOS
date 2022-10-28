//
//  NetworkError.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//

import Foundation



enum NetworkError: Error {
  case decodingError
  case badRequest
  case discorrect
  case duplicate
}

extension NetworkError {
  static func build(with statusCode: Int) -> NetworkError? {
    switch statusCode {
    case 400: return .badRequest
    case 401: return .discorrect
    case 409: return .duplicate
    default: return NetworkError.decodingError
    }
  }
}

extension NetworkError: Equatable {}
