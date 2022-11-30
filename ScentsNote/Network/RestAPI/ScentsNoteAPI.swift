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
  case fetchPerfumesRecent
  case fetchPerfumesNew(size: Int?)
  case fetchPerfumeDetail(perfumeIdx: Int)
  case fetchSimilarPerfumes(perfumeIdx: Int)
  case fetchPerfumesSearched(perfumeSearch: PerfumeSearchRequestDTO)
  
  // MARK: - Survey
  case registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int])
  
  // MARK: - Filter
  case fetchSeriesForFilter
  case fetchBrandForFilter
  
  // MARK: - Review
  case fetchReviews(perfumeIdx: Int)

}

extension ScentsNoteAPI: TargetType {
  public var baseURL: URL {
    var base = Config.Network.baseURL
    switch self {
    case .login, .signUp, .checkDuplicateEmail, .checkDuplicateNickname, .registerSurvey:
      base += "/user"
    case .fetchPerfumesInSurvey, .fetchPerfumesRecommended, .fetchPerfumesPopular, .fetchPerfumesRecent,
        .fetchPerfumesNew, .fetchPerfumeDetail, .fetchSimilarPerfumes, .fetchPerfumesSearched, .fetchReviews:
      base += "/perfume"
    case .fetchSeriesForFilter, .fetchBrandForFilter:
      base += "/filter"
    default:
      break
    }
    
    guard let url = URL(string: base) else {
      fatalError("baseURL could not be configured")
    }
    return url
  }
  
  // MARK: - Path
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
    case .fetchPerfumesRecent:
      return "/recent"
    case .fetchPerfumesNew:
      return "/new"
    case .fetchPerfumeDetail(let perfumeIdx):
      return "\(perfumeIdx)"
    case .fetchSimilarPerfumes(let perfumeIdx):
      return "\(perfumeIdx)/similar"
    case .fetchPerfumesSearched:
      return "/search"
      
    // MARK: - Survey
    case .registerSurvey:
      return "/survey"
      
    // MARK: - Filter
    case .fetchSeriesForFilter:
      return "/series"
    case .fetchBrandForFilter:
      return "/brand"
      
    // MARK: - Review
    case .fetchReviews(let perfumeIdx):
      return "\(perfumeIdx)/review"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login, .signUp, .registerSurvey, .fetchPerfumesSearched:
      return .post
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .login, .signUp,.checkDuplicateEmail, .checkDuplicateNickname, .registerSurvey, .fetchPerfumesNew, .fetchPerfumesSearched:
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
    case let .fetchPerfumesNew(size):
      guard let size = size else { break }
      params["requestSize"] = size
    case let .fetchPerfumesSearched(perfumeSearch):
      params["searchText"] = perfumeSearch.searchText
      params["keywordList"] = perfumeSearch.keywordList
      params["ingredientList"] = perfumeSearch.ingredientList
      params["brandList"] = perfumeSearch.brandList
      Log(params)
    default:
      break
    }
    return params
  }
  
  private var parameterEncoding: ParameterEncoding {
    switch self {
    case .checkDuplicateEmail, .checkDuplicateNickname, .fetchPerfumesNew:
      return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
    default:
      return JSONEncoding.default
    }
  }
}
