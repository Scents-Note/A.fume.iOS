//
//  DefaultAuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import RxSwift
import Moya
import Then

final class DefaultUserRepository: UserRepository {
  
  private let userService: UserService
  private let userDefaultsPersitenceService: UserDefaultsPersitenceService
  
  init(userService: UserService, userDefaultsPersitenceService: UserDefaultsPersitenceService){
    self.userService = userService
    self.userDefaultsPersitenceService = userDefaultsPersitenceService
  }
  
  func login(email: String, password: String) -> Observable<LoginInfo> {
    return self.userService.login(email: email, password: password)
  }
  
  func logout() {
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.token)
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.refreshToken)
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.userIdx)
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.nickname)
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.gender)
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.birth)
    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.isLoggedIn)
  }
  
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo> {
    return self.userService.signUp(signUpInfo: signUpInfo)
  }
  
  func checkDuplicateEmail(email: String) -> Observable<Bool> {
    return self.userService.checkDuplicateEmail(email: email)
  }
  
  func checkDuplicateNickname(nickname: String) -> Observable<Bool> {
    return self.userService.checkDuplicateNickname(nickname: nickname)
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<Bool> {
    return self.userService.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList)
  }
  
  func fetchPerfumesInMyPage(userIdx: Int) -> Observable<[PerfumeInMyPage]> {
    return self.userService.fetchPerfumesInMyPage(userIdx: userIdx)
      .map { $0.rows.map { $0.toDomain() } }
  }
  
  func updateUserInfo(userIdx: Int, userInfo: UserInfo) -> Observable<UserInfo> {
    let requestDTO = userInfo.toEntity()
    return self.userService.updateUserInfo(userIdx: userIdx, userInfo: requestDTO)
      .map { $0.toDomain() }
  }
  
  func changePassword(password: Password) -> Observable<String> {
    let requestDTO = password.toEntity()
    return self.userService.changePassword(password: requestDTO)
  }
  
  func fetchReviewsInMyPage() -> Observable<[ReviewInMyPage]> {
    self.userService.fetchReviewsInMyPage()
      .map { $0.map {$0.toDomain() }}
  }
  
  func saveLoginInfo(loginInfo: LoginInfo) {
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.token, value: loginInfo.token)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.refreshToken, value: loginInfo.refreshToken)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.userIdx, value: loginInfo.userIdx)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.nickname, value: loginInfo.nickname)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.gender, value: loginInfo.gender)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.birth, value: loginInfo.birth)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.isLoggedIn, value: true)
  }
  
  func set(key: String, value: Any?) {
      UserDefaults.standard.set(value, forKey: key)
  }
  
  func fetchUserDefaults<T>(key: String) -> T? {
    let value: T? = self.userDefaultsPersitenceService.get(key: key)
    return value
  }
  
  func saveUserInfo(userInfo: UserInfo) {
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.nickname, value: userInfo.nickname)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.gender, value: userInfo.gender)
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.birth, value: userInfo.birth)
  }
  
  func savePassword(password: String) {
    self.userDefaultsPersitenceService.set(key: UserDefaultKey.password, value: password)
  }
  
//  func clearUserInfo() {
//    self.userDefaultsPersitenceService.remove(key: UserDefaultKey.token)
//  }
}

