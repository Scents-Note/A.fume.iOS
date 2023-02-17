//
//  PerfumeReviewViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/29.
//

import Foundation

import RxSwift
import RxRelay

final class PerfumeReviewViewModel {
  
  enum Mode {
    case review
    case reviewUpdate
  }
  // MARK: - Input & Output
  struct Input {
    let perfumeDetailViewDidTapEvent = PublishRelay<Void>()
    let starViewDidUpdateEvent = PublishRelay<Double>()
    let noteTextFieldDidEditEvent = PublishRelay<String>()
    let keywordAddButtonDidTapEvent = PublishRelay<Void>()
    let longevityCellDidTapEvent = PublishRelay<Int>()
    let sillageCellDidTapEvent = PublishRelay<Int>()
    let seasonalCellDidTapEvent = PublishRelay<Int>()
    let genderCellDidTapEvent = PublishRelay<Int>()
    let shareButtonDidTapEvent = PublishRelay<Void>()
    let doneButtonDidTapEvent = PublishRelay<Void>()
    let deleteButtonDidTapEvent = PublishRelay<Void>()
    let updateButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct BottomSheetInput {
    let keywords = PublishRelay<[Keyword]>()
  }
  
  struct Output {
    let reviewDetail = BehaviorRelay<ReviewDetail?>(value: nil)
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let keywords = BehaviorRelay<[Keyword]>(value: [])
    let longevities = BehaviorRelay<[Longevity]>(value: [])
    let genders = BehaviorRelay<[Gender]>(value: [])
    let seasonals = BehaviorRelay<[Seasonal]>(value: [])
    let sillages = BehaviorRelay<[Sillage]>(value: [])
    let isShared = BehaviorRelay<Bool>(value: false)
    let canDone = BehaviorRelay<Bool>(value: false)
    let canUpdate = BehaviorRelay<Bool>(value: false)
    let showToast = PublishRelay<Void>()
    let pop = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: PerfumeReviewCoordinator?
  private var fetchKeywordsUseCase: FetchKeywordsUseCase?
  private var fetchReviewDetailUseCase: FetchReviewDetailUseCase?
  private var addReviewUseCase: AddReviewUseCase?
  private var updateReviewUseCase: UpdateReviewUseCase?
  private var deleteReviewUseCase: DeleteReviewUseCase?
  private let disposeBag = DisposeBag()
  
  let input = Input()
  let bottomSheetInput = BottomSheetInput()
  let output = Output()
  
  let mode: Mode
  var perfumeDetail: PerfumeDetail?
  var perfumeIdx: Int = 0
  var reviewIdx: Int = 0
  var keywords: [Keyword] = []
  
  
  // Vars for Request
  var oldReviewDetail: ReviewDetail?
  var newReviewDetail = ReviewDetail.default
  
  // MARK: - Life Cycle
  /// 작성한 review가 없을때
  init(coordinator: PerfumeReviewCoordinator,
       perfumeDetail: PerfumeDetail,
       addReviewUseCase: AddReviewUseCase,
       fetchKeywordsUseCase: FetchKeywordsUseCase) {
    self.coordinator = coordinator
    self.perfumeDetail = perfumeDetail
    self.perfumeIdx = perfumeDetail.perfumeIdx
    self.addReviewUseCase = addReviewUseCase
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    self.mode = .review
    
    self.transform(input: self.input, bottomSheetInput: self.bottomSheetInput, output: self.output)
  }
  
  /// 작성한 리뷰가 있을때
  init(coordinator: PerfumeReviewCoordinator,
       reviewIdx: Int,
       fetchReviewDetailUseCase: FetchReviewDetailUseCase,
       updateReviewUseCase: UpdateReviewUseCase,
       fetchKeywordsUseCase: FetchKeywordsUseCase,
       deleteReviewUseCase: DeleteReviewUseCase
  ) {
    self.coordinator = coordinator
    self.reviewIdx = reviewIdx
    self.fetchReviewDetailUseCase = fetchReviewDetailUseCase
    self.updateReviewUseCase = updateReviewUseCase
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    self.deleteReviewUseCase = deleteReviewUseCase
    self.mode = .reviewUpdate
    
    self.transform(input: self.input, bottomSheetInput: self.bottomSheetInput, output: self.output)
  }
  
  
  // MARK: - Binding
  func transform(input: Input, bottomSheetInput: BottomSheetInput, output: Output) {
    let reviewDetail = PublishRelay<ReviewDetail>()
    let keywords = BehaviorRelay<[Keyword]>(value: [])
    let longevities = BehaviorRelay<[Longevity]>(value: Longevity.default)
    let genders = BehaviorRelay<[Gender]>(value: Gender.default)
    let seasonals = BehaviorRelay<[Seasonal]>(value: Seasonal.default)
    let sillages = BehaviorRelay<[Sillage]>(value: Sillage.default)
    let isShared = BehaviorRelay<Bool>(value: false)
    let canDone = PublishRelay<Bool>()
    let canUpdate = PublishRelay<Bool>()
    let showToast = PublishRelay<Void>()
    let pop = PublishRelay<Void>()
    
    self.bindInput(input: input,
                   bottomSheetInput: bottomSheetInput,
                   keywords: keywords,
                   longevities: longevities,
                   sillages: sillages,
                   seasonals: seasonals,
                   genders: genders,
                   isShared: isShared,
                   canDone: canDone,
                   canUpdate: canUpdate,
                   showToast: showToast,
                   pop: pop)
    
    self.bindOutput(output: output,
                    reviewDetail: reviewDetail,
                    keywords: keywords,
                    longevities: longevities,
                    sillages: sillages,
                    seasonals: seasonals,
                    genders: genders,
                    isShared: isShared,
                    canDone: canDone,
                    canUpdate: canUpdate,
                    showToast: showToast,
                    pop: pop)
    
    self.fetchDatas(reviewDetail: reviewDetail)
  }
  
  private func bindInput(input: Input,
                         bottomSheetInput: BottomSheetInput,
                         keywords: BehaviorRelay<[Keyword]>,
                         longevities: BehaviorRelay<[Longevity]>,
                         sillages: BehaviorRelay<[Sillage]>,
                         seasonals: BehaviorRelay<[Seasonal]>,
                         genders: BehaviorRelay<[Gender]>,
                         isShared: BehaviorRelay<Bool>,
                         canDone: PublishRelay<Bool>,
                         canUpdate: PublishRelay<Bool>,
                         showToast: PublishRelay<Void>,
                         pop: PublishRelay<Void>) {
    
    // TODO: 통일
    input.perfumeDetailViewDidTapEvent
      .subscribe(onNext: { [weak self] _ in
        if self?.isPerfumeDetailPushed() == true {
          self?.coordinator?.finishFlow?()
        } else {
          self?.coordinator?.runPerfumeDetailFlow?(self?.perfumeIdx ?? 0)
          pop.accept(())
        }
      })
      .disposed(by: self.disposeBag)
    
    input.starViewDidUpdateEvent
      .subscribe(onNext: { [weak self] score in
        self?.newReviewDetail.score = score
        self?.checkChange(canUpdate: canUpdate)
      })
      .disposed(by: self.disposeBag)
    
    input.noteTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.newReviewDetail.content = text
        self?.checkChange(canUpdate: canUpdate)
      })
      .disposed(by: self.disposeBag)
    
    input.keywordAddButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let keywords = self?.keywords else { return }
        self?.coordinator?.showKeywordBottomSheetViewController(keywords: keywords)
      })
      .disposed(by: self.disposeBag)
    
    input.longevityCellDidTapEvent.withLatestFrom(longevities) { [weak self] updatedIdx, originals in
      self?.longevitiesUpdated(updatedIdx: updatedIdx, longevities: originals, canUpdate: canUpdate) ?? []
    }
    .bind(to: longevities)
    .disposed(by: self.disposeBag)
    
    input.sillageCellDidTapEvent.filter { $0 != 1 && $0 != 3}
      .withLatestFrom(sillages) { [weak self] updatedIdx, originals in
        self?.sillagesUpdated(updatedIdx: updatedIdx, sillages: originals, canUpdate: canUpdate) ?? []
      }
      .bind(to: sillages)
      .disposed(by: self.disposeBag)
    
    input.seasonalCellDidTapEvent.withLatestFrom(seasonals) { [weak self] updatedIdx, originals in
      self?.seasonalUpdated(updatedIdx: updatedIdx, seasonals: originals, canUpdate: canUpdate) ?? []
    }
    .bind(to: seasonals)
    .disposed(by: self.disposeBag)
    
    input.genderCellDidTapEvent.filter { $0 != 1 && $0 != 3}
      .withLatestFrom(genders) { [weak self] updatedIdx, originals in
        self?.gendersUpdated(updatedIdx: updatedIdx, genders: originals, canUpdate: canUpdate) ?? []
      }
      .bind(to: genders)
      .disposed(by: self.disposeBag)
    
    input.shareButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        let isAccessable = self?.newReviewDetail.isShared ?? false
        self?.newReviewDetail.isShared = !isAccessable
        self?.checkChange(canUpdate: canUpdate)
        isShared.accept(!isAccessable)
      })
      .disposed(by: self.disposeBag)
    
    input.deleteButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showPopup()
      })
      .disposed(by: self.disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkRegister(detail: self?.newReviewDetail,
                            showToast: showToast)
      })
      .disposed(by: self.disposeBag)
    
    input.updateButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkRegister(detail: self?.newReviewDetail,
                            showToast: showToast)
      })
      .disposed(by: self.disposeBag)
    
    bottomSheetInput.keywords
      .subscribe(onNext: { [weak self] updated in
        let selected = updated.filter { $0.isSelected }
        keywords.accept(selected)
        self?.newReviewDetail.keywords = selected
        self?.checkChange(canUpdate: canUpdate)
        self?.keywords = updated
      })
      .disposed(by: self.disposeBag)
    
    Observable.combineLatest(input.starViewDidUpdateEvent, input.noteTextFieldDidEditEvent)
      .subscribe(onNext: { score, text in
        guard score != 0, text.count != 0 else {
          canDone.accept(false)
          return
        }
        canDone.accept(true)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output,
                          reviewDetail: PublishRelay<ReviewDetail>,
                          keywords: BehaviorRelay<[Keyword]>,
                          longevities: BehaviorRelay<[Longevity]>,
                          sillages: BehaviorRelay<[Sillage]>,
                          seasonals: BehaviorRelay<[Seasonal]>,
                          genders: BehaviorRelay<[Gender]>,
                          isShared: BehaviorRelay<Bool>,
                          canDone: PublishRelay<Bool>,
                          canUpdate: PublishRelay<Bool>,
                          showToast: PublishRelay<Void>,
                          pop: PublishRelay<Void>) {
    
    if let perfumeDetail = self.perfumeDetail {
      output.perfumeDetail.accept(perfumeDetail)
    }
    
    reviewDetail
      .subscribe(onNext: { [weak self] reviewDetail in
        self?.setReviewDetail(output: output,
                              reviewDetail: reviewDetail,
                              keywords: keywords,
                              longevities: longevities,
                              sillages: sillages,
                              seasonals: seasonals,
                              genders: genders,
                              isShared: isShared,
                              canDone: canDone,
                              canUpdate: canUpdate)
      })
      .disposed(by: self.disposeBag)
    
    
    keywords
      .bind(to: output.keywords)
      .disposed(by: self.disposeBag)
    
    longevities
      .bind(to: output.longevities)
      .disposed(by: self.disposeBag)
    
    genders
      .bind(to: output.genders)
      .disposed(by: self.disposeBag)
    
    seasonals
      .bind(to: output.seasonals)
      .disposed(by: self.disposeBag)
    
    sillages
      .bind(to: output.sillages)
      .disposed(by: self.disposeBag)
    
    isShared
      .bind(to: output.isShared)
      .disposed(by: self.disposeBag)
    
    canDone
      .bind(to: output.canDone)
      .disposed(by: self.disposeBag)
    
    canUpdate
      .bind(to: output.canUpdate)
      .disposed(by: self.disposeBag)
    
    showToast
      .bind(to: output.showToast)
      .disposed(by: self.disposeBag)
    
    pop
      .bind(to: output.pop)
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - Network
  private func fetchDatas(reviewDetail: PublishRelay<ReviewDetail>) {
    self.fetchKeywordsUseCase?.execute()
      .subscribe { [weak self] result in
        self?.keywords = result
      } onError: { error in
        Log(error)
      }
      .disposed(by: self.disposeBag)
    
    if self.reviewIdx != 0 {
      self.fetchReviewDetailUseCase?.execute(reviewIdx: reviewIdx)
        .subscribe { [weak self] result in
          self?.perfumeIdx = result.perfume?.idx ?? 0
          reviewDetail.accept(result)
        } onError: { error in
          Log(error)
        }
        .disposed(by: self.disposeBag)
    }
  }
  
  private func registerReview() {
    let selectedKeywords = self.keywords.filter { $0.isSelected }
    
    let perfumeReview = ReviewDetail(score: self.newReviewDetail.score,
                                     sillage: self.newReviewDetail.sillage,
                                     longevity: self.newReviewDetail.longevity,
                                     seasonal: self.newReviewDetail.seasonal,
                                     gender: self.newReviewDetail.gender,
                                     content: self.newReviewDetail.content,
                                     reviewIdx: self.newReviewDetail.reviewIdx,
                                     perfume: nil,
                                     keywords: selectedKeywords,
                                     brand: nil,
                                     isShared: self.newReviewDetail.isShared)
    
    if self.reviewIdx == 0 {
      self.addReviewUseCase?.execute(perfumeIdx: self.perfumeDetail!.perfumeIdx, perfumeReview: perfumeReview)
        .subscribe(onNext: { [weak self] _ in
          self?.coordinator?.finishFlow?()
        }, onError: { error in
          Log(error)
        })
        .disposed(by: self.disposeBag)
    } else {
      self.updateReviewUseCase?.execute(reviewDetail: perfumeReview)
        .subscribe(onNext: { [weak self] _ in
          self?.coordinator?.finishFlow?()
        }, onError: { error in
          Log(error)
        })
        .disposed(by: self.disposeBag)
    }
  }
  
  private func checkRegister(detail: ReviewDetail?, showToast: PublishRelay<Void>) {
    if self.newReviewDetail.isShared {
      let review = self.newReviewDetail
      if review.longevity == -1 || review.sillage == -1 || review.keywords.isEmpty || review.gender == -1 || review.seasonal.isEmpty {
        showToast.accept(())
        return
      }
    }
    self.registerReview()
  }
  
  
  // Review 가 존재할때 초기 세팅
  private func setReviewDetail(output: Output,
                               reviewDetail: ReviewDetail,
                               keywords: BehaviorRelay<[Keyword]>,
                               longevities: BehaviorRelay<[Longevity]>,
                               sillages: BehaviorRelay<[Sillage]>,
                               seasonals: BehaviorRelay<[Seasonal]>,
                               genders: BehaviorRelay<[Gender]>,
                               isShared: BehaviorRelay<Bool>,
                               canDone: PublishRelay<Bool>,
                               canUpdate: PublishRelay<Bool>) {
    
    let updatedLongevity = self.longevitiesUpdated(updatedIdx: reviewDetail.longevity,
                                                   longevities: longevities.value,
                                                   canUpdate: canUpdate)
    let updatedSillage = self.sillagesUpdated(updatedIdx: 2 * reviewDetail.sillage,
                                              sillages: sillages.value,
                                              canUpdate: canUpdate)
    let updatedSeasonal = self.seasonalUpdated(newSeasonals: reviewDetail.seasonal,
                                               seasonals: seasonals.value,
                                               canUpdate: canUpdate)
    let updatedGender = self.gendersUpdated(updatedIdx: 2 * reviewDetail.gender,
                                            genders: genders.value,
                                            canUpdate: canUpdate)
    
    self.newReviewDetail = reviewDetail
    self.oldReviewDetail = reviewDetail
    output.reviewDetail.accept(reviewDetail)
    keywords.accept(reviewDetail.keywords)
    longevities.accept(updatedLongevity)
    sillages.accept(updatedSillage)
    seasonals.accept(updatedSeasonal)
    genders.accept(updatedGender)
    isShared.accept(reviewDetail.isShared)
    
    self.updateKeywords(keywords: keywords.value)
    
  }
  
  // MARK: - Update
  private func updateKeywords(keywords: [Keyword]) {
    let list = keywords.map { $0.idx }
    self.keywords.enumerated().forEach { [weak self] idx, keyword in
      if list.contains(keyword.idx) {
        self?.keywords[idx].isSelected = true
      }
    }
  }
  
  private func checkChange(canUpdate: PublishRelay<Bool>) {
    if self.oldReviewDetail == self.newReviewDetail || self.newReviewDetail.content.isEmpty {
      canUpdate.accept(false)
    } else {
      canUpdate.accept(true)
    }
  }
  
  private func longevitiesUpdated(updatedIdx: Int,
                                  longevities: [Longevity],
                                  canUpdate: PublishRelay<Bool>) -> [Longevity] {
    self.newReviewDetail.longevity = updatedIdx
    self.checkChange(canUpdate: canUpdate)
    return longevities.enumerated().map { idx, longevity in
      Longevity(longevity: longevity.longevity, duration: longevity.duration, percent: longevity.percent, isAccent: updatedIdx == idx, isEmpty: longevity.isEmpty)
    }
  }
  
  private func sillagesUpdated(updatedIdx: Int,
                               sillages: [Sillage],
                               canUpdate: PublishRelay<Bool>) -> [Sillage] {
    self.newReviewDetail.sillage = updatedIdx / 2
    self.checkChange(canUpdate: canUpdate)
    return sillages.enumerated().map { idx, sillage in
      Sillage(sillage: sillage.sillage, percent: sillage.percent, isAccent: updatedIdx == idx)
    }
  }
  
  ///  `남성` : 0 `중성` : 2 `여성`: 4
  ///  클릭에 의해서 변경 될 때
  private func seasonalUpdated(updatedIdx: Int,
                               seasonals: [Seasonal],
                               canUpdate: PublishRelay<Bool>) -> [Seasonal] {
    let updatedSeasonals = seasonals.enumerated().map { idx, seasonal in
      guard idx != updatedIdx else {
        return Seasonal(season: seasonal.season, percent: seasonal.percent, color: seasonal.color, isAccent: !seasonal.isAccent)
      }
      return seasonal
    }
    self.newReviewDetail.seasonal = updatedSeasonals.filter { $0.isAccent }.map { $0.season }
    self.checkChange(canUpdate: canUpdate)
    return updatedSeasonals
  }
  
  
  private func seasonalUpdated(newSeasonals: [String],
                               seasonals: [Seasonal],
                               canUpdate: PublishRelay<Bool>) -> [Seasonal] {
    let indice = seasonalIdice(newSeasonals)
    let updatedSeasonals = seasonals.enumerated().map { idx, seasonal in
      guard !indice.contains(idx) else {
        return Seasonal(season: seasonal.season, percent: seasonal.percent, color: seasonal.color, isAccent: true)
      }
      return seasonal
    }
    self.newReviewDetail.seasonal = updatedSeasonals.filter { $0.isAccent }.map { $0.season }
    self.checkChange(canUpdate: canUpdate)
    return updatedSeasonals
  }
  
  ///  `남성` : 0 `중성` : 2 `여성`: 4
  private func gendersUpdated(updatedIdx: Int, genders: [Gender], canUpdate: PublishRelay<Bool>) -> [Gender] {
    self.newReviewDetail.gender = updatedIdx / 2
    self.checkChange(canUpdate: canUpdate)
    return genders.enumerated().map { idx, gender in
      Gender(gender: gender.gender, percent: gender.percent, color: gender.color, isAccent: updatedIdx == idx)
    }
  }
  
  ///  `봄` : 0 `여름`: 1 `가을` : 2 `겨울`: 3
  private func seasonalIdice(_ newSeasonals: [String]) -> [Int] {
    var indice: [Int] = []
    newSeasonals.forEach {
      switch $0 {
      case "봄":
        indice += [0]
      case "여름":
        indice += [1]
      case "가을":
        indice += [2]
      default:
        indice += [3]
      }
    }
    
    return indice
  }
  
  /// `true` : 향수 상세 페이지가 기존에 존재해서 리뷰 페이지를 pop 처리 해줌
  /// `false` : 향수 상세 페이지가 없어 push를 통해 향수 상세 페이지를 띄워줌
  private func isPerfumeDetailPushed() -> Bool {
    return (self.coordinator as? DefaultPerfumeReviewCoordinator)?.findViewController(PerfumeDetailViewController.self) != nil
  }
  
}

extension PerfumeReviewViewModel: BottomSheetDismissDelegate {
  /// `Keyword BottomSheet`에서 키워드 적용시 콜백 함수
  func setKeywordsFromBottomSheet(keywords: [Keyword]) {
    self.bottomSheetInput.keywords.accept(keywords)
  }
}

extension PerfumeReviewViewModel: LabelPopupDelegate {
  /// 삭제 확인 팝업에서 확인 클릭시
  func confirm() {
    self.deleteReviewUseCase?.execute(reviewIdx: self.reviewIdx)
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.finishFlow?()
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
}
