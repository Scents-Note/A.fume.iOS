//
//  PerfumeRepositoryMock.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2022/12/26.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockPerfumeRepository: PerfumeRepository {
  
  private let perfumes: [Perfume] = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
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
  
  private let perfumesSimilar: [Perfume] = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                              Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                              Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                              Perfume(perfumeIdx: 3, brandName: "라", name: "ㄹ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                              Perfume(perfumeIdx: 4, brandName: "마", name: "ㅁ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
  
  private let reviews: [ReviewInPerfumeDetail] = [ReviewInPerfumeDetail(idx: 0, score: 5, access: true, content: "가", likeCount: 0, isLiked: false, gender: 1, age: "20", nickname: "득연1", isReported: false),
                                                  ReviewInPerfumeDetail(idx: 1, score: 4.5, access: true, content: "나", likeCount: 0, isLiked: false, gender: 1, age: "30", nickname: "득연2", isReported: false)]
  
  private let series: [SurveySeries] = [SurveySeries(seriesIdx: 0, name: "가", imageUrl: ""),
                                        SurveySeries(seriesIdx: 1, name: "나", imageUrl: ""),
                                        SurveySeries(seriesIdx: 2, name: "다", imageUrl: ""),
                                        SurveySeries(seriesIdx: 3, name: "라", imageUrl: "")]
  
  private let perfumeDetail: PerfumeDetail = PerfumeDetail(perfumeIdx: 0, name: "가", brandName: "ㄱ", story: "story", abundanceRate: "풍부", volumeAndPrice: ["90ml, 50,000원"], imageUrls: [], score: 5.0, seasonal: [], sillage: [], longevity: [], gender: [], isLiked: false, Keywords: [], noteType: 0, ingredients: [], reviewIdx: 0)
  
  func updatePerfumeLike(perfumeIdx: Int) -> Observable<Bool> {
    Observable.create { observer in
      observer.onNext(true)
      return Disposables.create()
    }
  }
  
  func fetchPerfumesInSurvey() -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumes = self?.perfumes else { return Disposables.create()}
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func fetchSeries() -> Observable<[SurveySeries]> {
    Observable.create { [weak self] observer in
      guard let series = self?.series else { return Disposables.create()}
      observer.onNext(series)
      return Disposables.create()
    }
  }
  
  func fetchPerfumesRecommended() -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumes = self?.perfumes else { return Disposables.create()}
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func fetchPerfumesPopular() -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumes = self?.perfumes else { return Disposables.create()}
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func fetchPerfumesRecent() -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumes = self?.perfumes else { return Disposables.create()}
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func fetchPerfumesNew(size: Int?) -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumes = self?.perfumes else { return Disposables.create()}
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func fetchPerfumeDetail(perfumeIdx: Int) -> Observable<PerfumeDetail> {
    Observable.create { [weak self] observer in
      guard let perfumeDetail = self?.perfumeDetail else {
        return Disposables.create()
      }
      observer.onNext(perfumeDetail)
      return Disposables.create()
    }
  }
  
  func fetchSimliarPerfumes(perfumeIdx: Int) -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumesSimilar = self?.perfumesSimilar else { return Disposables.create()}
      observer.onNext(perfumesSimilar)
      return Disposables.create()
    }
  }
  
  func fetchPerfumeSearched(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]> {
    Observable.create { [weak self] observer in
      guard let perfumes = self?.perfumes else { return Disposables.create()}
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
  
  func fetchReviewsInPerfumeDetail(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]> {
    Observable.create { [weak self] observer in
      guard let reviews = self?.reviews else { return Disposables.create()}
      observer.onNext(reviews)
      return Disposables.create()
    }
  }
  
  func addReview(perfumeIdx: Int, perfumeReview: ReviewDetail) -> Observable<String> {
    Observable.create { observer in
      observer.onNext("노트 작성에 성공하였습니다.")
      return Disposables.create()
    }
  }
}
