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
  
  // MARK: - Input & Output
  struct CellInput {
    let perfumeCellDidTapEvent: PublishRelay<Perfume>
    let perfumeHeartButtonDidTapEvent: PublishRelay<Perfume>
    let moreCellDidTapEvent: PublishRelay<Bool>
  }
  
  struct Output {
    var homeDatas = BehaviorRelay<[HomeDataSection.Model]>(value: HomeDataSection.default)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: HomeCoordinator?
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase
  private let fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase
  private let fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase
  private let fetchPerfumesNewUseCase: FetchPerfumesNewUseCase
  
  init(coordinator: HomeCoordinator,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase,
       fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase,
       fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase,
       fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase,
       fetchPerfumesNewUseCase: FetchPerfumesNewUseCase) {
    self.coordinator = coordinator
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    self.fetchPerfumesRecommendedUseCase = fetchPerfumesRecommendedUseCase
    self.fetchPerfumesPopularUseCase = fetchPerfumesPopularUseCase
    self.fetchPerfumesRecentUseCase = fetchPerfumesRecentUseCase
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
  }
  
  
  
  // MARK: - TransForm
  func transform(from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let perfumesRecommended = BehaviorRelay<[Perfume]>(value: [])
    let perfumesPopular = BehaviorRelay<[Perfume]>(value: [])
    let perfumesRecent = BehaviorRelay<[Perfume]>(value: [])
    let perfumesNew = BehaviorRelay<[Perfume]>(value: [])
    
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
                             perfumesRecommended: BehaviorRelay<[Perfume]>,
                             perfumesPopular: BehaviorRelay<[Perfume]>,
                             perfumesRecent: BehaviorRelay<[Perfume]>,
                             perfumesNew: BehaviorRelay<[Perfume]>,
                             disposeBag: DisposeBag) {
    cellInput.perfumeCellDidTapEvent
      .subscribe { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow(perfumeIdx: perfume.perfumeIdx)
      }
      .disposed(by: disposeBag)

    cellInput.perfumeHeartButtonDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.updatePerfumeLikeUseCase.execute(perfumeIdx: perfume.perfumeIdx)
          .subscribe(onNext: { [weak self] _ in
            self?.updatePerfumeLike(perfumeIdx: perfume.perfumeIdx,
                                    perfumesPopular: perfumesPopular,
                                    perfumesRecent: perfumesRecent,
                                    perfumesNew: perfumesNew)
          })
          .disposed(by: disposeBag)
      }) { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
    cellInput.moreCellDidTapEvent
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.runPerfumeNewFlow()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          perfumesRecommended: BehaviorRelay<[Perfume]>,
                          perfumesPopular: BehaviorRelay<[Perfume]>,
                          perfumesRecent: BehaviorRelay<[Perfume]>,
                          perfumesNew: BehaviorRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    
    /// 초기값 [] 이 들어가므로 1번 skip
    perfumesRecommended.skip(1).withLatestFrom(output.homeDatas) { perfumes, homeDatas in
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
    
    perfumesPopular.skip(1).withLatestFrom(output.homeDatas) { perfumes, homeDatas in
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
    
    perfumesRecent.skip(1).withLatestFrom(output.homeDatas){ perfumes, homeDatas in
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
      } else { /// Recent 가 없거나 로그인이 안될 때 Cell을 없애주기 위함
        let updatedDatas = homeDatas.filter { $0.model != .recent}
        return updatedDatas
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: disposeBag)
    
    perfumesNew.skip(1).withLatestFrom(output.homeDatas) { updated, originals in
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
  private func fetchDatas(perfumesRecommended: BehaviorRelay<[Perfume]>,
                          perfumesPopular: BehaviorRelay<[Perfume]>,
                          perfumesRecent: BehaviorRelay<[Perfume]>,
                          perfumesNew: BehaviorRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    
    self.fetchPerfumesRecommendedUseCase.execute()
      .subscribe { perfumes in
        perfumesRecommended.accept(perfumes)
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
    self.fetchPerfumesPopularUseCase.execute()
      .subscribe { perfumes in
        perfumesPopular.accept(perfumes)
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
    self.fetchPerfumesRecentUseCase.execute()
      .subscribe { perfumes in
        perfumesRecent.accept(perfumes)
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
    self.fetchPerfumesNewUseCase.execute(size: 10)
      .subscribe { perfumes in
        perfumesNew.accept(perfumes)
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
  }
  // MARK: - Action
  private func updatePerfumeLike(perfumeIdx: Int,
                                 perfumesPopular: BehaviorRelay<[Perfume]>,
                                 perfumesRecent: BehaviorRelay<[Perfume]>,
                                 perfumesNew: BehaviorRelay<[Perfume]>) {
    
    let updatedPerfumesPopular = togglePerfumeLike(perfumeIdx: perfumeIdx, originals: perfumesPopular.value)
    let updatedPerfumesRecent = togglePerfumeLike(perfumeIdx: perfumeIdx, originals: perfumesRecent.value)
    let updatedPerfumesNew = togglePerfumeLike(perfumeIdx: perfumeIdx, originals: perfumesNew.value)
    
    perfumesPopular.accept(updatedPerfumesPopular)
    perfumesRecent.accept(updatedPerfumesRecent)
    perfumesNew.accept(updatedPerfumesNew)
  }
  
  private func togglePerfumeLike(perfumeIdx: Int, originals perfumes: [Perfume]) -> [Perfume] {
    perfumes.map {
      guard $0.perfumeIdx != perfumeIdx else {
        var updatePerfume = $0
        updatePerfume.isLiked = !updatePerfume.isLiked
        return updatePerfume
      }
      return $0
    }
  }
  
}
