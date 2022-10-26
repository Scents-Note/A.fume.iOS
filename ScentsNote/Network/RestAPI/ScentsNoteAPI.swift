//
//  ScentsNoteApi.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Moya
import Alamofire

enum ScentsNoteAPI {
  case login(email: String, password: String)
}

extension ScentsNoteAPI: TargetType {
  public var baseURL: URL {
    var base = Config.Network.baseURL
    switch self {
    case .login:
      base += "/user"
    }
    
    guard let url = URL(string: base) else {
      fatalError("baseURL could not be configured")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .login:
      return "/login"
    default :
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .login:
      return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
    }
  }
  
  var headers: [String: String]? {
//    if let userToken = Logged.userToken {
//      return [
//        "x-access-token": "Bearer " + userToken,
//        "Content-Type": "application/json"
//      ]
//    }
    return nil
  }
  
  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
    case let .login(email, password):
      params["email"] = email
      params["password"] = password
    }
    return params
  }
  
  private var parameterEncoding: ParameterEncoding {
    switch self {
    default:
      return JSONEncoding.default
    }
  }
  
  public var validationType: ValidationType {
    return .successCodes
  }
  
}

//extension ScentsNoteApi
