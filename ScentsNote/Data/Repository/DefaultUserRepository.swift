//
//  DefaultAuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import RxSwift
import Moya

final class DefaultUserRepository: UserRepository {
  
  private let userService: UserService
  
  init(userService: UserService){
    self.userService = userService
  }
  
  func login(email: String, password: String, completion: @escaping (Result<LoginInfo?, NetworkError>) -> Void) {
    return self.userService.login(email: email, password: password, completion: completion)
  }
  
  func signUp(signUpInfo: SignUpInfo, completion: @escaping (Result<LoginInfo?, NetworkError>) -> Void) {
    return self.userService.signUp(signUpInfo: signUpInfo, completion: completion)
  }
  
  func checkDuplicateEmail(email: String, completion: @escaping (Result<Bool?, NetworkError>) -> Void) {
    return self.userService.checkDuplicateEmail(email: email, completion: completion)
  }
  
  func checkDuplicateNickname(nickname: String, completion: @escaping (Result<Bool?, NetworkError>) -> Void) {
    return self.userService.checkDuplicateNickname(nickname: nickname, completion: completion)
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int], completion: @escaping (Result<Bool?, NetworkError>) -> Void) {
    return self.userService.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList, completion: completion)
  }
  
  func saveLoginInfo(loginInfo: LoginInfo) {
    UserDefaults.standard.set(loginInfo.token, forKey: UserDefaultKey.token)
    UserDefaults.standard.set(loginInfo.nickname, forKey: UserDefaultKey.nickname)
    UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn)
  }
}

