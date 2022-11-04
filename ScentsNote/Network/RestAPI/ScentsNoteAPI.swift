//
//  ScentsNoteApi.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Moya
import Alamofire

enum ScentsNoteAPI {
  // MARK: - User
  case login(email: String, password: String)
  case signUp(signUpInfo: SignUpInfo)
  case checkDuplicateEmail(email: String)
  case checkDuplicateNickname(nickname: String)
  
  // MARK: - Perfume
  case fetchPerfumesInSurvey
  case fetchKeywords
  case fetchSeries
}

extension ScentsNoteAPI: TargetType {
  public var baseURL: URL {
    var base = Config.Network.baseURL
    switch self {
    case .login, .signUp, .checkDuplicateEmail, .checkDuplicateNickname:
      base += "/user"
    case .fetchPerfumesInSurvey:
      base += "/perfume"
    default:
      break
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
    case .signUp:
      return "/register"
    case .checkDuplicateEmail:
      return "/validate/email"
    case .checkDuplicateNickname:
      return "/validate/name"
    case .fetchPerfumesInSurvey:
      return "/survey"
    case .fetchKeywords:
      return "/keyword"
    case .fetchSeries:
      return "/series"
    }

  }
  
  var method: Moya.Method {
    switch self {
    case .login, .signUp:
      return .post
    case .checkDuplicateEmail, .checkDuplicateNickname, .fetchPerfumesInSurvey, .fetchKeywords, .fetchSeries:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .login, .signUp,.checkDuplicateEmail, .checkDuplicateNickname:
      return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
    case .fetchPerfumesInSurvey, .fetchKeywords, .fetchSeries:
      return .requestPlain
    }
  }
  
  var headers: [String: String]? {
    // TODO: propertyWrapper 사용해볼것
    if let userToken = UserDefaults.standard.string(forKey: UserDefaultKey.token) {
      return [
        "x-access-token": "Bearer " + userToken,
        "Content-Type": "application/json"
      ]
    }
    
    return nil
  }
  
  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
    case let .login(email, password):
      params["email"] = email
      params["password"] = password
    case let .signUp(signUpInfo):
      params["password"] = signUpInfo.password
      params["email"] = signUpInfo.email
      params["nickname"] = signUpInfo.nickname
      params["gender"] = signUpInfo.gender
      params["birth"] = signUpInfo.birth
      params["grade"] = signUpInfo.grade
    case let .checkDuplicateEmail(email):
      params["email"] = email
    case let .checkDuplicateNickname(nickname):
      params["nickname"] = nickname
    default:
      break
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
