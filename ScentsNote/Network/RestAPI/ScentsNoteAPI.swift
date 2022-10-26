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
  case checkDuplicateEmail(email: String)
  case checkDuplicateNickname(nickname: String)
}

extension ScentsNoteAPI: TargetType {
  public var baseURL: URL {
    var base = Config.Network.baseURL
    switch self {
    case .login, .checkDuplicateEmail, .checkDuplicateNickname:
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
    case .checkDuplicateEmail:
      return "/validate/email"
    case .checkDuplicateNickname:
      return "/validate/name"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login:
      return .post
    case .checkDuplicateEmail, .checkDuplicateNickname:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .login, .checkDuplicateEmail, .checkDuplicateNickname:
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
    case let .checkDuplicateEmail(email):
      params["email"] = email
    case let .checkDuplicateNickname(nickname):
      params["nickname"] = nickname
    }
    return params
  }
  
  private var parameterEncoding: ParameterEncoding {
    switch self {
    case .checkDuplicateEmail, .checkDuplicateNickname:
      return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
    default:
      return JSONEncoding.default
    }
  }
  
  public var validationType: ValidationType {
    return .successCodes
  }
  
}

//extension ScentsNoteApi
