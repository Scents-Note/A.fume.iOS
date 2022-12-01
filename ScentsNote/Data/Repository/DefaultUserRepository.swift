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
  
  func login(email: String, password: String) -> Observable<LoginInfo> {
    return self.userService.login(email: email, password: password)
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
  
  func fetchPerfumesLiked(userIdx: Int) -> Observable<[PerfumeLiked]> {
    return self.userService.fetchPerfumesLiked(userIdx: userIdx)
      .map { $0.rows.map { $0.toDomain() } }
  }
  
  func updateUserInfo(userIdx: Int, userInfo: UserInfo) -> Observable<UserInfo> {
    let userInfoResponseDTO = userInfo.toEntity()
    return self.userService.updateUserInfo(userIdx: userIdx, userInfo: userInfoResponseDTO)
      .map { $0.toDomain() }
  }
  
  func saveLoginInfo(loginInfo: LoginInfo) {
    UserDefaults.standard.set(loginInfo.token, forKey: UserDefaultKey.token)
    UserDefaults.standard.set(loginInfo.userIdx, forKey: UserDefaultKey.userIdx)
    UserDefaults.standard.set(loginInfo.nickname, forKey: UserDefaultKey.nickname)
    UserDefaults.standard.set(loginInfo.gender, forKey: UserDefaultKey.gender)
    UserDefaults.standard.set(loginInfo.birth, forKey: UserDefaultKey.birth)
    UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn)
  }
  
  func fetchUserIdx() -> Int? {
    UserDefaults.standard.integer(forKey: UserDefaultKey.userIdx)
  }
  
  func fetchUserToken() -> String? {
    UserDefaults.standard.string(forKey: UserDefaultKey.token)
  }
  
  func fetchLoginState() -> Bool? {
    UserDefaults.standard.bool(forKey: UserDefaultKey.isLoggedIn)
  }
  
  func fetchUserGender() -> String? {
    UserDefaults.standard.string(forKey: UserDefaultKey.gender)
  }
  
  func fetchUserNickname() -> String? {
    UserDefaults.standard.string(forKey: UserDefaultKey.nickname)
  }
  
  func fetchUserBirth() -> Int? {
    UserDefaults.standard.integer(forKey: UserDefaultKey.birth)
  }
  
  func saveUserInfo(userInfo: UserInfo) {
    UserDefaults.standard.set(userInfo.nickname, forKey: UserDefaultKey.nickname)
    UserDefaults.standard.set(userInfo.gender, forKey: UserDefaultKey.gender)
    UserDefaults.standard.set(userInfo.birth, forKey: UserDefaultKey.birth)
  }
}

