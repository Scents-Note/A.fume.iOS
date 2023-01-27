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
  struct Input {
    let viewWillAppearEvent = PublishRelay<Void>()
  }
  
  struct CellInput {
    let perfumeCellDidTapEvent = PublishRelay<Perfume>()
    let perfumeHeartButtonDidTapEvent = PublishRelay<Perfume>()
    let moreCellDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    var homeDatas = BehaviorRelay<[HomeDataSection.Model]>(value: HomeDataSection.default)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: HomeCoordinator?
  private let fetchUserDefaultUseCase: FetchUserDefaultUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase
  private let fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase
  private let fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase
  private let fetchPerfumesNewUseCase: FetchPerfumesNewUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let cellInput = CellInput()
  let output = Output()
  
  var isLoggedIn: Bool?
  var oldIsLoggedIn: Bool?
  var birth = 1990
  var gender = "남"
  var nickname = ""
  
  init(coordinator: HomeCoordinator,
       fetchUserDefaultUseCase: FetchUserDefaultUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase,
       fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase,
       fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase,
       fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase,
       fetchPerfumesNewUseCase: FetchPerfumesNewUseCase) {
    self.coordinator = coordinator
    self.fetchUserDefaultUseCase = fetchUserDefaultUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    self.fetchPerfumesRecommendedUseCase = fetchPerfumesRecommendedUseCase
    self.fetchPerfumesPopularUseCase = fetchPerfumesPopularUseCase
    self.fetchPerfumesRecentUseCase = fetchPerfumesRecentUseCase
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
    
    self.transform(input: self.input, cellInput: self.cellInput, output: self.output)
  }
  
  // MARK: - TransForm
  func transform(input: Input, cellInput: CellInput, output: Output) {
    let loadData = PublishRelay<Void>()
    let perfumesRecommended = BehaviorRelay<[Perfume]>(value: [])
    let perfumesPopular = BehaviorRelay<[Perfume]>(value: [])
    let perfumesRecent = BehaviorRelay<[Perfume]>(value: [])
    let perfumesNew = BehaviorRelay<[Perfume]>(value: [])
    
    self.bindInput(input: input,
                   cellInput: cellInput,
                   loadData: loadData,
                   perfumesRecommended: perfumesRecommended,
                   perfumesPopular: perfumesPopular,
                   perfumesRecent: perfumesRecent,
                   perfumesNew: perfumesNew)
    
    self.bindOutput(output: output,
                    perfumesRecommended: perfumesRecommended,
                    perfumesPopular: perfumesPopular,
                    perfumesRecent: perfumesRecent,
                    perfumesNew: perfumesNew)
    
    self.fetchDatas(loadData: loadData,
                    perfumesRecommended: perfumesRecommended,
                    perfumesPopular: perfumesPopular,
                    perfumesRecent: perfumesRecent,
                    perfumesNew: perfumesNew)
    
  }
  
  private func bindInput(input: Input,
                         cellInput: CellInput,
                         loadData: PublishRelay<Void>,
                         perfumesRecommended: BehaviorRelay<[Perfume]>,
                         perfumesPopular: BehaviorRelay<[Perfume]>,
                         perfumesRecent: BehaviorRelay<[Perfume]>,
                         perfumesNew: BehaviorRelay<[Perfume]>) {
    input.viewWillAppearEvent
      .bind(to: loadData)
      .disposed(by: self.disposeBag)
    
    cellInput.perfumeCellDidTapEvent
      .subscribe { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow(perfumeIdx: perfume.perfumeIdx)
      }
      .disposed(by: self.disposeBag)
    
    cellInput.perfumeHeartButtonDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.updatePerfumeLike(perfumeIdx: perfume.perfumeIdx,
                                perfumesPopular: perfumesPopular,
                                perfumesRecent: perfumesRecent,
                                perfumesNew: perfumesNew)
      })
      .disposed(by: self.disposeBag)
    
    cellInput.moreCellDidTapEvent
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.runPerfumeNewFlow()
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output,
                          perfumesRecommended: BehaviorRelay<[Perfume]>,
                          perfumesPopular: BehaviorRelay<[Perfume]>,
                          perfumesRecent: BehaviorRelay<[Perfume]>,
                          perfumesNew: BehaviorRelay<[Perfume]>) {
    
    /// 초기값 [] 이 들어가므로 1번 skip
    perfumesRecommended.skip(1).withLatestFrom(output.homeDatas) { perfumes, homeDatas in
      homeDatas.map { [weak self] in
        if case .recommendation = $0.model {
          let item = HomeDataSection.HomeItem.recommendation(perfumes)
          let content = self?.getRecommedationContent(isLoggedIn: self?.isLoggedIn, nickname: self?.nickname) ?? .default
          let sectionModel = HomeDataSection.Model(model: .recommendation(HomeDataSection.Content(title: content.title, content: content.content)), items: [item])
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: self.disposeBag)
    
    perfumesPopular.skip(1).withLatestFrom(output.homeDatas) { perfumes, homeDatas in
      homeDatas.map { [weak self] in
        if case .popularity = $0.model {
          let items = perfumes.map {HomeDataSection.HomeItem.popularity($0) }
          let content = self?.getPopularContent(isLoggedIn: self?.isLoggedIn,
                                                birth: self?.birth,
                                                gender: self?.gender,
                                                nickname: self?.nickname) ?? .default
          let sectionModel = HomeDataSection.Model(model: .popularity(HomeDataSection.Content(title: content.title, content: content.content)), items: items)
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: self.disposeBag)
    
    perfumesRecent.skip(1).withLatestFrom(output.homeDatas){ [weak self] perfumes, homeDatas in
      if self?.isLoggedIn == true && perfumes.count != 0 {
        let updatedDatas = homeDatas.map {
          if case .recent = $0.model {
            let items = perfumes.map {HomeDataSection.HomeItem.recent($0) }
            let sectionModel = HomeDataSection.Model(model: .recent(HomeDataSection.Content(title: "최근 찾아본 향수", content: "")), items: items)
            return sectionModel
          }
          return $0
        }
        return updatedDatas
      } else {
        let updatedDatas = homeDatas.filter {
          if case .recent = $0.model {
            return false
          }
          return true
        }
        return updatedDatas
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: self.disposeBag)
    
    perfumesNew.skip(1).withLatestFrom(output.homeDatas) { updated, originals in
      originals.map {
        if case .new = $0.model {
          let items = updated.map {HomeDataSection.HomeItem.new($0) }
          let sectionModel = HomeDataSection.Model(model: .new(HomeDataSection.Content(title: "새로\n등록된 향수", content: "기대하세요. 새로운 향수가 업데이트 됩니다.")), items: items)
          return sectionModel
        }
        return $0
      }
    }
    .bind(to: output.homeDatas)
    .disposed(by: self.disposeBag)
  }
  
  // MARK: - Network Fetch
  private func fetchDatas(loadData: PublishRelay<Void>,
                          perfumesRecommended: BehaviorRelay<[Perfume]>,
                          perfumesPopular: BehaviorRelay<[Perfume]>,
                          perfumesRecent: BehaviorRelay<[Perfume]>,
                          perfumesNew: BehaviorRelay<[Perfume]>) {
    
    loadData
      .subscribe(onNext: { [weak self] in
        self?.setUserInfo()
        
        /// 로그인 로그아웃 할때만 recommendation 바뀌게. 안그러면 로그아웃 상태에서 willAppear 시에 계속 바뀜.
        if self?.oldIsLoggedIn != self?.isLoggedIn {
          self?.fetchPerfumesRecommendedUseCase.execute()
            .subscribe { perfumes in
              self?.oldIsLoggedIn = self?.isLoggedIn
              perfumesRecommended.accept(perfumes)
            } onError: { error in
              Log(error)
            }
            .disposed(by: self?.disposeBag ?? DisposeBag())
        }
        
        self?.fetchPerfumesPopularUseCase.execute()
          .subscribe { perfumes in
            perfumesPopular.accept(perfumes)
          } onError: { error in
            Log(error)
          }
          .disposed(by: self?.disposeBag ?? DisposeBag())
        
        if self?.isLoggedIn == true {
          self?.fetchPerfumesRecentUseCase.execute()
            .subscribe { perfumes in
              perfumesRecent.accept(perfumes)
            } onError: { error in
              Log(error)
            }
            .disposed(by: self?.disposeBag ?? DisposeBag())
        } else {
          perfumesRecent.accept([])
        }
        
        self?.fetchPerfumesNewUseCase.execute(size: 10)
          .subscribe { perfumes in
            perfumesNew.accept(perfumes)
          } onError: { error in
            Log(error)
          }
          .disposed(by: self?.disposeBag ?? DisposeBag())
      })
      .disposed(by: self.disposeBag)
    
  }
  // MARK: - Action
  private func updatePerfumeLike(perfumeIdx: Int,
                                 perfumesPopular: BehaviorRelay<[Perfume]>,
                                 perfumesRecent: BehaviorRelay<[Perfume]>,
                                 perfumesNew: BehaviorRelay<[Perfume]>) {
    
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: perfumeIdx)
      .subscribe(onNext: { [weak self] _ in
        self?.updatePerfumeLikeIfSuccess(perfumeIdx: perfumeIdx,
                                         perfumesPopular: perfumesPopular,
                                         perfumesRecent: perfumesRecent,
                                         perfumesNew: perfumesNew)
      }, onError: { [weak self] error in
        Log(error)
        self?.coordinator?.showPopup()
      })
      .disposed(by: self.disposeBag)
    
    
    
  }
  
  private func updatePerfumeLikeIfSuccess(perfumeIdx: Int,
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
  
  private func setUserInfo() {
    self.isLoggedIn = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn) ?? false
    self.birth = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.birth) ?? 1990
    self.gender = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.gender) ?? ""
    self.nickname = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.nickname) ?? ""
  }
  
  private func getRecommedationContent(isLoggedIn: Bool?, nickname: String?) -> HomeDataSection.Content {
    if isLoggedIn == true {
      return HomeDataSection.Content(title: "\(nickname ?? "")님을 위한\n향수 추천", content: "센츠노트를 사용할수록\n더 잘 맞는 향수를 보여드려요.")
    } else {
      return HomeDataSection.Content(title: "당신을 위한\n향수 추천", content: "센츠노트를 사용할수록\n더 잘 맞는 향수를 보여드려요.")
    }
  }
  
  private func getPopularContent(isLoggedIn: Bool?, birth: Int?, gender: String?, nickname: String?) -> HomeDataSection.Content {
    if isLoggedIn == true {
      guard let birth = birth, let gender = gender, let nickname = nickname else { return .default }
      let year = Calendar.current.component(.year, from: Date())
      let age = (year - birth + 1) / 10 * 10
      let modifiedGender = gender == "MAN" ? "남성" : "여성"
      return HomeDataSection.Content(title: "\(age)대 \(modifiedGender)을 위한\n향수 추천", content: "\(nickname)님 연령대 분들에게 인기 많은 향수 입니다.")
    } else {
      return HomeDataSection.Content(title: "20대 여성이\n많이 찾는 향수", content: "20대 분들에게 인기 많은 향수 입니다.")
    }
  }
  
}

extension HomeViewModel: LabelPopupDelegate {
  func confirm() {
    self.coordinator?.runOnboardingFlow?()
  }
}
