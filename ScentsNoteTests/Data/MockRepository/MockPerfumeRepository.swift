//
//  MockPerfumeRepository.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2022/12/26.
//

import RxSwift
@testable import ScentsNote

final class MockPerfumeRepository: PerfumeRepository {
  
  private let mockPerfumes: [Perfume] = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 3, brandName: "라", name: "ㄹ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 4, brandName: "마", name: "ㅁ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 5, brandName: "바", name: "ㅂ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 6, brandName: "사", name: "ㅅ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 7, brandName: "아", name: "ㅇ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 8, brandName: "자", name: "ㅈ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 9, brandName: "차", name: "ㅊ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 10, brandName: "카", name: "ㅋ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                         Perfume(perfumeIdx: 11, brandName: "티", name: "ㅌ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
  
  private let mockReviews: [ReviewInPerfumeDetail] = [ReviewInPerfumeDetail(idx: 0, score: 5, access: true, content: "가", likeCount: 0, isLiked: false, gender: 1, age: "20", nickname: "득연1", isReported: false),
                                                      ReviewInPerfumeDetail(idx: 1, score: 4.5, access: true, content: "나", likeCount: 0, isLiked: false, gender: 1, age: "30", nickname: "득연2", isReported: false)]
  
  private let mockPerfumeDetail: PerfumeDetail = PerfumeDetail(perfumeIdx: 0, name: "가", brandName: "ㄱ", story: "story", abundanceRate: "풍부", volumeAndPrice: ["90ml, 50,000원"], imageUrls: [], score: 5.0, seasonal: [], sillage: [], longevity: [], gender: [], isLiked: false, Keywords: [], noteType: 0, ingredients: [], reviewIdx: 0)
  
  func updatePerfumeLike(perfumeIdx: Int) -> Observable<Bool> {
    Observable.just(true)
  }
  
  func fetchPerfumesInSurvey() -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchSeries() -> Observable<ListInfo<SurveySeries>> {
    Observable.just(ListInfo(count: 0, rows: []))
  }
  
  func fetchPerfumesRecommended() -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchPerfumesPopular() -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchPerfumesRecent() -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchPerfumesNew(size: Int?) -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail> {
    Observable.just(mockPerfumeDetail)
  }
  
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]> {
    Observable.just(mockPerfumes)
  }
  
  func fetchReviewsInPerfumeDetail(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]> {
    Observable.just(mockReviews)
  }
  
  func addReview(perfumeIdx: Int, perfumeReview: ReviewDetail) -> Observable<String> {
    Observable.just("success")
  }
  
  
}
