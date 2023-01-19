//
//  MockUserRepository.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import RxSwift
@testable import ScentsNote

final class MockUserRepository: UserRepository {
  
  func login(email: String, password: String) -> Observable<LoginInfo> {
    let loginInfo = LoginInfo(userIdx: 0, nickname: "Testemr", gender: "MAN", birth: 1995, token: "", refreshToken: "")
    return Observable.create { observer in
      observer.onNext(loginInfo)
      return Disposables.create()
    }
  }
  
  func signUp(signUpInfo: ScentsNote.SignUpInfo) -> Observable<LoginInfo> {
    let loginInfo = LoginInfo(userIdx: 0, nickname: "Testemr", gender: "MAN", birth: 1995, token: "", refreshToken: "")
    return Observable.create { observer in
      observer.onNext(loginInfo)
      return Disposables.create()
    }
  }
  
  func checkDuplicateEmail(email: String) -> Observable<Bool> {
    return Observable.create { observer in
      observer.onNext(true)
      return Disposables.create()
    }
  }
  
  func checkDuplicateNickname(nickname: String) -> Observable<Bool> {
    return Observable.create { observer in
      observer.onNext(true)
      return Disposables.create()
    }
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<String> {
    let description = "등록에 성공하였습니다."
    return Observable.create { observer in
      observer.onNext(description)
      return Disposables.create()
    }
  }
  
  func fetchPerfumesInMyPage(userIdx: Int) -> Observable<[PerfumeInMyPage]> {
    let perfumes = [PerfumeInMyPage(idx: 0, name: "가", brandName: "ㄱ", imageUrl: "", reviewIdx: 100),
                    PerfumeInMyPage(idx: 1, name: "나", brandName: "ㄴ", imageUrl: "", reviewIdx: 101),
                    PerfumeInMyPage(idx: 2, name: "다", brandName: "ㄷ", imageUrl: "", reviewIdx: 102),
                    PerfumeInMyPage(idx: 3, name: "라", brandName: "ㄹ", imageUrl: "", reviewIdx: 103)]
    return Observable.create { observer in
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func updateUserInfo(userIdx: Int, userInfo: EditUserInfo) -> Observable<EditUserInfo> {
    let editUserInfo = EditUserInfo(nickname: "득연", gender: "남", birth: 1995)
    return Observable.create { observer in
      observer.onNext(editUserInfo)
      return Disposables.create()
    }
  }
  
  func changePassword(password: Password) -> Observable<String> {
    let description = "변경되었습니다."
    return Observable.create { observer in
      observer.onNext(description)
      return Disposables.create()
    }
  }
  
  func fetchReviewsInMyPage() -> Observable<[ReviewInMyPage]> {
    let reviews = [ReviewInMyPage(reviewIdx: 0, score: 5.0, perfume: "가", imageUrl: "", brand: "ㄱ"),
                   ReviewInMyPage(reviewIdx: 1, score: 4.5, perfume: "나", imageUrl: "", brand: "ㄴ"),
                   ReviewInMyPage(reviewIdx: 2, score: 3.7, perfume: "다", imageUrl: "", brand: "ㄱ"),
                   ReviewInMyPage(reviewIdx: 3, score: 5.0, perfume: "라", imageUrl: "", brand: "ㄱ"),
                   ReviewInMyPage(reviewIdx: 4, score: 4.5, perfume: "마", imageUrl: "", brand: "ㄴ"),
                   ReviewInMyPage(reviewIdx: 5, score: 3.7, perfume: "바", imageUrl: "", brand: "ㄱ")]
    
    return Observable.create { observer in
      observer.onNext(reviews)
      return Disposables.create()
    }
  }
  
  func fetchUserDefaults<T>(key: String) -> T? {
    let value = "test"
    return value as? T
  }
  
  func setUserDefault(key: String, value: Any?) {}
  
  func removeUserDefault(key: String) {}
}
