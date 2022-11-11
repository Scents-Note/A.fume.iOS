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
  
  func login(email: String, password: String) -> Observable<LoginInfo?> {
    return self.userService.login(email: email, password: password)
  }
  
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo?> {
    return self.userService.signUp(signUpInfo: signUpInfo)
  }
  
  func checkDuplicateEmail(email: String) -> Observable<Bool?> {
    return self.userService.checkDuplicateEmail(email: email)
  }
  
  func checkDuplicateNickname(nickname: String) -> Observable<Bool?> {
    return self.userService.checkDuplicateNickname(nickname: nickname)
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<Bool?> {
    return self.userService.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList)
  }
  
  func saveLoginInfo(loginInfo: LoginInfo) {
    UserDefaults.standard.set(loginInfo.token, forKey: UserDefaultKey.token)
    UserDefaults.standard.set(loginInfo.nickname, forKey: UserDefaultKey.nickname)
    UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn)
  }
}

