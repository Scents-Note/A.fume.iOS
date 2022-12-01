//
//  AuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation
import RxSwift
import Moya

protocol UserRepository {
  // MARK: - Login
  func login(email: String, password: String) -> Observable<LoginInfo>
  func saveLoginInfo(loginInfo: LoginInfo)
  
  // MARK: - SignUp
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo>
  func checkDuplicateEmail(email: String) -> Observable<Bool>
  func checkDuplicateNickname(nickname: String) -> Observable<Bool>
  
  // MARK: - Survey
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<Bool>

  // MARK: - My Page
  func fetchPerfumesLiked(userIdx: Int) -> Observable<[PerfumeLiked]>

  func fetchUserIdx() -> Int?
  func fetchUserToken() -> String?
  func fetchLoginState() -> Bool?

}

