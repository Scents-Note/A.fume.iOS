//
//  HomeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay
import Moya

final class HomeViewModel {
  weak var coordinator: HomeCoordinator?
  var perfumeRepository: PerfumeRepository
  
  init(coordinator: HomeCoordinator, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
  }
  
  struct CellInput {
    let perfumeCellDidTapEvent: PublishRelay<Perfume>
    let popularPerfumeHeartButtonDidTapEvent: PublishRelay<Perfume>
    let recentPerfumeHeartButtonDidTapEvent: PublishRelay<Perfume>
    let newPerfumeHeartButtonDidTapEvent: PublishRelay<Perfume>
    let moreCellDidTapEvent: PublishRelay<Bool>
  }
  
  struct Output {
    var homeDatas = BehaviorRelay<[HomeDataSection.Model]>(value: HomeDataSection.default)
  }
  
  func transform(from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    
    let output = Output()
    let perfumesRecommended = PublishRelay<[Perfume]>()
    let perfumesPopular = PublishRelay<[Perfume]>()
    let perfumesRecent = PublishRelay<[Perfume]>()
    let perfumesNew = PublishRelay<[Perfume]>()
    
    self.bindCellInput(cellInput: cellInput,
                       perfumesRecommended: perfumesRecommended,
                       perfumesPopular: perfumesPopular,
                       perfumesRecent: perfumesRecent,
                       perfumesNew: perfumesNew,
                       disposeBag: disposeBag)
    
    self.bindOutput(output: output,
                    perfumesRecommended: perfumesRecommended,
                    perfumesPopular: perfumesPopular,
                    perfumesRecent: perfumesRecent,
                    perfumesNew: perfumesNew,
                    disposeBag: disposeBag)
    
    // TODO: willAppear로 빼기
    self.fetchDatas(perfumesRecommended: perfumesRecommended,
                    perfumesPopular: perfumesPopular,
                    perfumesRecent: perfumesRecent,
                    perfumesNew: perfumesNew,
                    disposeBag: disposeBag)
    
    return output
  }
  
  private func bindCellInput(cellInput: CellInput,
                             perfumesRecommended: PublishRelay<[Perfume]>,
                             perfumesPopular: PublishRelay<[Perfume]>,
                             perfumesRecent: PublishRelay<[Perfume]>,
                             perfumesNew: PublishRelay<[Perfume]>,
                             disposeBag: DisposeBag) {
    cellInput.perfumeCellDidTapEvent
      .subscribe { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow(perfumeIdx: perfume.perfumeIdx)
      }
      .disposed(by: disposeBag)
    
    cellInput.popularPerfumeHeartButtonDidTapEvent.withLatestFrom(perfumesPopular) { updated, originals in
      originals.map {
        guard $0.perfumeIdx != updated.perfumeIdx else {
          var item = updated
          item.isLiked.toggle()
          return item
        }
        return $0
      }
    }
    .bind(to: perfumesPopular)
    .disposed(by: disposeBag)
    
    cellInput.recentPerfumeHeartButtonDidTapEvent.withLatestFrom(perfumesRecent) { updated, originals in
      originals.map {
        guard $0.perfumeIdx != updated.perfumeIdx else {
          var item = updated
          item.isLiked.toggle()
          return item
        }
        return $0
      }
    }
    .bind(to: perfumesRecent)
    .disposed(by: disposeBag)
    
    cellInput.newPerfumeHeartButtonDidTapEvent.withLatestFrom(perfumesNew) { updated, originals in
      originals.map {
        guard $0.perfumeIdx != updated.perfumeIdx else {
          var item = updated
          item.isLiked.toggle()
          return item
        }
        return $0
      }
    }
    .bind(to: perfumesNew)
    .disposed(by: disposeBag)
    
    cellInput.moreCellDidTapEvent
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.runPerfumeNewFlow()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          perfumesRecommended: PublishRelay<[Perfume]>,
                          perfumesPopular: PublishRelay<[Perfume]>,
                          perfumesRecent: PublishRelay<[Perfume]>,
                          perfumesNew: PublishRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    
    perfumesRecommended.withLatestFrom(output.homeDatas) { perfumes, homeDatas in
      homeDatas.map {
        guard $0.model != .recommendation else {
          let item = HomeDataSection.HomeItem.recommendation(perfumes)
          let sectionModel = HomeDataSection.Model(model: .recommendation, items: [item])
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)
    
    perfumesPopular.withLatestFrom(output.homeDatas) { perfumes, homeDatas in
      homeDatas.map {
        guard $0.model != .popularity else {
          let items = perfumes.map {HomeDataSection.HomeItem.popularity($0) }
          let sectionModel = HomeDataSection.Model(model: .popularity, items: items)
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)
    
    perfumesRecent.withLatestFrom(output.homeDatas) { perfumes, homeDatas in
      if perfumes.count != 0 {
        let updatedDatas = homeDatas.map {
          guard $0.model != .recent else {
            let items = perfumes.map {HomeDataSection.HomeItem.recent($0) }
            let sectionModel = HomeDataSection.Model(model: .recent, items: items)
            return sectionModel
          }
          return $0
        }
        return updatedDatas
      } else {
        let updatedDatas = homeDatas.filter { $0.model != .recent}
        return updatedDatas
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
  }
  
  // MARK: - Network Fetch
  private func fetchDatas(perfumesRecommended: PublishRelay<[Perfume]>,
                          perfumesPopular: PublishRelay<[Perfume]>,
                          perfumesRecent: PublishRelay<[Perfume]>,
                          perfumesNew: PublishRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    self.perfumeRepository.fetchPerfumesRecommended()
      .subscribe { perfumes in
        guard let perfumes = perfumes else { return }
        perfumesRecommended.accept(perfumes)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchPerfumesPopular()
      .subscribe { perfumes in
        guard let perfumes = perfumes else { return }
        perfumesPopular.accept(perfumes)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchPerfumesRecent()
      .subscribe { perfumes in
        guard let perfumes = perfumes else { return }
        perfumesRecent.accept(perfumes)
      } onError: { error in
        switch error {
        case let NetworkError.restError(statusCode, description):
          perfumesRecent.accept([])
          Log("\(statusCode!) & \(description!)")
        default:
          break
        }
        
      }
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchPerfumesNew(size: 10)
      .subscribe { perfumes in
        guard let perfumes = perfumes else { return }
        perfumesNew.accept(perfumes)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
  }
  
  //  func dummy() -> [Perfume] {
  //    return [Perfume(perfumeIdx: -1, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false), Perfume(perfumeIdx: -2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -3, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 4, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -5, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -6, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -7, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false)]
  //
  //  }
  
}
