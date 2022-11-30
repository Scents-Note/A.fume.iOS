//
//  DefaultUserService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/22.
//

import Foundation
import RxSwift
import Moya

final class DefaultUserService: ScentsNoteService, UserService {
  
  static let shared: DefaultUserService = DefaultUserService()
  
  func login(email: String, password: String) -> Observable<LoginInfo> {
    requestObject(.login(email: email, password: password))
  }
  
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo> {
    requestObject(.signUp(signUpInfo: signUpInfo))
  }
  
  func checkDuplicateEmail(email: String) -> Observable<Bool> {
    requestObject(.checkDuplicateEmail(email: email))
  }
  
  func checkDuplicateNickname(nickname: String) -> Observable<Bool> {
    requestObject(.checkDuplicateNickname(nickname: nickname))
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<Bool> {
    requestObject(.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList))
  }
  
  func fetchPerfumesLiked(userIdx: Int) -> Observable<ListInfo<PerfumeLikedResponseDTO>> {
    requestObject(.fetchPerfumesLiked(uesrIdx: userIdx))
  }

}

