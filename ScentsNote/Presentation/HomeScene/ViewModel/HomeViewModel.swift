//
//  HomeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay

final class HomeViewModel {
  weak var coordinator: HomeCoordinator?
  var perfumeRepository: PerfumeRepository

  init(coordinator: HomeCoordinator, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
  }
  
  struct Input {
    
  }
  
  struct Output {
    var homeDatas = BehaviorRelay<[HomeDataSection.Model]>(value: HomeDataSection.initialSectionDatas)
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    
    let perfumesRecommended = PublishRelay<[Perfume]>()
    let perfumesPopular = PublishRelay<[Perfume]>()
    let perfumesRecent = PublishRelay<[Perfume]>()
    let perfumesNew = PublishRelay<[Perfume]>()
    
    let output = Output()
    
    let dummyList =  [Perfume(perfumeIdx: 1, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false), Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false)]

    // MARK: - Network
    /// viewController의 DisposeBag을 사용하기 위해 따로 빼지 않고 놨는데 역할 분리가 좀 아쉬운 듯
    self.perfumeRepository.fetchPerfumesRecommended()
      .subscribe { listInfo in
        guard let listInfo = listInfo else { return }
        perfumesRecommended.accept(listInfo.rows)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchPerfumesPopular()
      .subscribe { listInfo in
        guard let listInfo = listInfo else { return }
        perfumesPopular.accept(listInfo.rows)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchPerfumesRecommended()
      .subscribe { listInfo in
        guard let listInfo = listInfo else { return }
        perfumesRecent.accept(listInfo.rows)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchNewPerfumes()
      .subscribe { listInfo in
        guard let listInfo = listInfo else { return }
        perfumesNew.accept(listInfo.rows)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    // MARK: - Input
    
    perfumesRecommended.withLatestFrom(output.homeDatas) { (updated, originals) -> [HomeDataSection.Model] in
      originals.map {
        guard $0.model != .recommendation else {
          let item = HomeDataSection.HomeItem.recommendation(updated)
          let sectionModel = HomeDataSection.Model(model: .recommendation, items: [item])
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)
    
    perfumesPopular.withLatestFrom(output.homeDatas) { (updated, originals) -> [HomeDataSection.Model] in
      originals.map {
        guard $0.model != .popularity else {
          let items = updated.map {HomeDataSection.HomeItem.popularity($0) }
          let sectionModel = HomeDataSection.Model(model: .popularity, items: items)
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)
    
    perfumesRecent.withLatestFrom(output.homeDatas) { (updated, originals) -> [HomeDataSection.Model] in
      originals.map {
        guard $0.model != .recent else {
          let items = dummyList.map {HomeDataSection.HomeItem.recent($0) }
          let sectionModel = HomeDataSection.Model(model: .recent, items: items)
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)

    perfumesNew.withLatestFrom(output.homeDatas) { updated, originals in
      originals.map {
        guard $0.model != .new else {
          let items = updated.map {HomeDataSection.HomeItem.new($0) }
          let sectionModel = HomeDataSection.Model(model: .new, items: items)
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)

    return output
  }
  
}
