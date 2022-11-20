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
  case fetchPerfumesRecommended
  case fetchPerfumesPopular
  case fetchRecentPerfumes
  case fetchNewPerfumes
  case fetchPerfumeDetail(perfumeIdx: Int)
  case fetchSimilarPerfumes(perfumeIdx: Int)
  
  // MARK: - Survey
  case registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int])
  
}

extension ScentsNoteAPI: TargetType {
  public var baseURL: URL {
    var base = Config.Network.baseURL
    switch self {
    case .login, .signUp, .checkDuplicateEmail, .checkDuplicateNickname, .registerSurvey:
      base += "/user"
    case .fetchPerfumesInSurvey, .fetchPerfumesRecommended, .fetchPerfumesPopular, .fetchRecentPerfumes, .fetchNewPerfumes, .fetchPerfumeDetail, .fetchSimilarPerfumes:
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
      // MARK: - Login
    case .login:
      return "/login"
      
      // MARK: - SignUp
    case .signUp:
      return "/register"
    case .checkDuplicateEmail:
      return "/validate/email"
    case .checkDuplicateNickname:
      return "/validate/name"
      
        // MARK: - Perfume
    case .fetchPerfumesInSurvey:
      return "/survey"
    case .fetchKeywords:
      return "/keyword"
    case .fetchSeries:
      return "/series"
    case .fetchPerfumesRecommended:
      return "/recommend/personal"
    case .fetchPerfumesPopular:
      return "/recommend/common"
    case .fetchRecentPerfumes:
      return "/recent"
    case .fetchNewPerfumes:
      return "/new"
    case .fetchPerfumeDetail(let perfumeIdx):
      return "\(perfumeIdx)"
    case .fetchSimilarPerfumes(let perfumeIdx):
      return "\(perfumeIdx)/similar"
      
        // MARK: - Survey
    case .registerSurvey:
      return "/survey"
    }

  }
  
  var method: Moya.Method {
    switch self {
    case .login, .signUp, .registerSurvey:
      return .post
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .login, .signUp,.checkDuplicateEmail, .checkDuplicateNickname, .registerSurvey:
      return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
    default:
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
    case let .registerSurvey(perfumeList, keywordList, seriesList):
      params["perfumeList"] = perfumeList
      params["keywordList"] = keywordList
      params["seriesList"] = seriesList
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
}
