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
  struct BottomSheetInput {
    let keywords = PublishRelay<[Keyword]>()
  }
  
  struct Input {
    let imageContainerDidTapEvent: Observable<UITapGestureRecognizer>
    let starViewDidUpdateEvent: PublishRelay<Double>
    let noteTextFieldDidEditEvent: Observable<String>
    let keywordAddButtonDidTapEvent: Observable<Void>
    let longevityCellDidTapEvent: Observable<Int>
    let sillageCellDidTapEvent: Observable<Int>
    let seasonalCellDidTapEvent: Observable<Int>
    let genderCellDidTapEvent: Observable<Int>
    let shareButtonDidTapEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
    let deleteButtonDidTapEvent: Observable<Void>
    let updateButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let reviewDetail = BehaviorRelay<ReviewDetail?>(value: nil)
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let keywords = BehaviorRelay<[Keyword]>(value: [])
    let longevities = BehaviorRelay<[Longevity]>(value: [])
    let genders = BehaviorRelay<[Gender]>(value: [])
    let seasonals = BehaviorRelay<[Seasonal]>(value: [])
    let sillages = BehaviorRelay<[Sillage]>(value: [])
    let isShareButtonSelected = BehaviorRelay<Bool>(value: false)
    let canDone = BehaviorRelay<Bool>(value: false)
    let canUpdate = BehaviorRelay<Bool>(value: false)
    let showToast = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: PerfumeReviewCoordinator?
  private var fetchKeywordsUseCase: FetchKeywordsUseCase?
  private var fetchReviewDetailUseCase: FetchReviewDetailUseCase?
  private var addReviewUseCase: AddReviewUseCase?
  private var updateReviewUseCase: UpdateReviewUseCase?
  private var deleteReviewUseCase: DeleteReviewUseCase?
  private let mode: Mode
  
  private let disposeBag = DisposeBag()
  private var perfumeDetail: PerfumeDetail?
  private var reviewIdx: Int = 0
  private var keywords: [Keyword] = []
  
  private let bottomSheetInput = BottomSheetInput()
  
  // Vars for Request
  private var oldReviewDetail: ReviewDetail?
  private var newReviewDetail = ReviewDetail.default
  
  // MARK: - Life Cycle
  /// 작성한 review가 없을때
  init(coordinator: PerfumeReviewCoordinator,
       perfumeDetail: PerfumeDetail,
       addReviewUseCase: AddReviewUseCase,
       fetchKeywordsUseCase: FetchKeywordsUseCase) {
    self.coordinator = coordinator
    self.perfumeDetail = perfumeDetail
    self.addReviewUseCase = addReviewUseCase
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    self.mode = .review
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
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let reviewDetail = PublishRelay<ReviewDetail>()
    let keywords = BehaviorRelay<[Keyword]>(value: [])
    let longevities = BehaviorRelay<[Longevity]>(value: Longevity.default)
    let genders = BehaviorRelay<[Gender]>(value: Gender.default)
    let seasonals = BehaviorRelay<[Seasonal]>(value: Seasonal.default)
    let sillages = BehaviorRelay<[Sillage]>(value: Sillage.default)
    let isShareButtonSelected = BehaviorRelay<Bool>(value: false)
    let canDone = PublishRelay<Bool>()
    let canUpdate = PublishRelay<Bool>()
    let showToast = PublishRelay<Void>()
    
    self.bindInput(input: input,
                   bottomSheetInput: bottomSheetInput,
                   keywords: keywords,
                   longevities: longevities,
                   sillages: sillages,
                   seasonals: seasonals,
                   genders: genders,
                   isShareButtonSelected: isShareButtonSelected,
                   canDone: canDone,
                   canUpdate: canUpdate,
                   showToast: showToast,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: output,
                    reviewDetail: reviewDetail,
                    keywords: keywords,
                    longevities: longevities,
                    sillages: sillages,
                    seasonals: seasonals,
                    genders: genders,
                    isShareButtonSelected: isShareButtonSelected,
                    canDone: canDone,
                    canUpdate: canUpdate,
                    showToast: showToast,
                    disposeBag: disposeBag)
    
    self.fetchDatas(reviewDetail: reviewDetail, disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input,
                         bottomSheetInput: BottomSheetInput,
                         keywords: BehaviorRelay<[Keyword]>,
                         longevities: BehaviorRelay<[Longevity]>,
                         sillages: BehaviorRelay<[Sillage]>,
                         seasonals: BehaviorRelay<[Seasonal]>,
                         genders: BehaviorRelay<[Gender]>,
                         isShareButtonSelected: BehaviorRelay<Bool>,
                         canDone: PublishRelay<Bool>,
                         canUpdate: PublishRelay<Bool>,
                         showToast: PublishRelay<Void>,
                         disposeBag: DisposeBag) {
    
    input.imageContainerDidTapEvent
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.finishFlow?()
      })
      .disposed(by: disposeBag)
    
    input.starViewDidUpdateEvent
      .subscribe(onNext: { [weak self] score in
        self?.newReviewDetail.score = score
        self?.checkChange(canUpdate: canUpdate)
      })
      .disposed(by: disposeBag)
    
    input.noteTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.newReviewDetail.content = text
        self?.checkChange(canUpdate: canUpdate)
      })
      .disposed(by: disposeBag)
    
    input.keywordAddButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let keywords = self?.keywords else { return }
        self?.coordinator?.showKeywordBottomSheetViewController(keywords: keywords)
      })
      .disposed(by: disposeBag)
    
    input.longevityCellDidTapEvent.withLatestFrom(longevities) { [weak self] updatedIdx, originals in
      self?.longevitiesUpdated(updatedIdx: updatedIdx, longevities: originals, canUpdate: canUpdate) ?? []
    }
    .bind(to: longevities)
    .disposed(by: disposeBag)
    
    input.sillageCellDidTapEvent.withLatestFrom(sillages) { [weak self] updatedIdx, originals in
      self?.sillagesUpdated(updatedIdx: updatedIdx, sillages: originals, canUpdate: canUpdate) ?? []
    }
    .bind(to: sillages)
    .disposed(by: disposeBag)
    
    input.seasonalCellDidTapEvent.withLatestFrom(seasonals) { [weak self] updatedIdx, originals in
      self?.seasonalUpdated(updatedIdx: updatedIdx, seasonals: originals, canUpdate: canUpdate) ?? []
    }
    .bind(to: seasonals)
    .disposed(by: disposeBag)
    
    input.genderCellDidTapEvent.withLatestFrom(genders) { [weak self] updatedIdx, originals in
      self?.gendersUpdated(updatedIdx: updatedIdx, genders: originals, canUpdate: canUpdate) ?? []
    }
    .bind(to: genders)
    .disposed(by: disposeBag)
    
    input.shareButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        let isAccessable = self?.newReviewDetail.access ?? false
        self?.newReviewDetail.access = !isAccessable
        self?.checkChange(canUpdate: canUpdate)
        isShareButtonSelected.accept(!isAccessable)
      })
      .disposed(by: disposeBag)
    
    input.deleteButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
//        self?.confirm()
        self?.coordinator?.showDeletePopup()
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkRegister(detail: self?.newReviewDetail,
                            showToast: showToast,
                            disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.updateButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.checkRegister(detail: self?.newReviewDetail,
                            showToast: showToast,
                            disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    bottomSheetInput.keywords
      .subscribe(onNext: { [weak self] updated in
        let selected = updated.filter { $0.isSelected }
        keywords.accept(selected)
        self?.newReviewDetail.keywords = selected
        self?.checkChange(canUpdate: canUpdate)
        self?.keywords = updated
      })
      .disposed(by: disposeBag)
    
    Observable.combineLatest(input.starViewDidUpdateEvent, input.noteTextFieldDidEditEvent)
      .subscribe(onNext: { score, text in
        guard score != 0, text.count != 0 else {
          canDone.accept(false)
          return
        }
        canDone.accept(true)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          reviewDetail: PublishRelay<ReviewDetail>,
                          keywords: BehaviorRelay<[Keyword]>,
                          longevities: BehaviorRelay<[Longevity]>,
                          sillages: BehaviorRelay<[Sillage]>,
                          seasonals: BehaviorRelay<[Seasonal]>,
                          genders: BehaviorRelay<[Gender]>,
                          isShareButtonSelected: BehaviorRelay<Bool>,
                          canDone: PublishRelay<Bool>,
                          canUpdate: PublishRelay<Bool>,
                          showToast: PublishRelay<Void>,
                          disposeBag: DisposeBag) {
    
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
                              isShareButtonSelected: isShareButtonSelected,
                              canDone: canDone,
                              canUpdate: canUpdate,
                              disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    
    keywords
      .bind(to: output.keywords)
      .disposed(by: disposeBag)
    
    longevities
      .bind(to: output.longevities)
      .disposed(by: disposeBag)
    
    genders
      .bind(to: output.genders)
      .disposed(by: disposeBag)
    
    seasonals
      .bind(to: output.seasonals)
      .disposed(by: disposeBag)
    
    sillages
      .bind(to: output.sillages)
      .disposed(by: disposeBag)
    
    isShareButtonSelected
      .bind(to: output.isShareButtonSelected)
      .disposed(by: disposeBag)
    
    canDone
      .bind(to: output.canDone)
      .disposed(by: disposeBag)
    
    canUpdate
      .bind(to: output.canUpdate)
      .disposed(by: disposeBag)
    
    showToast
      .bind(to: output.showToast)
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - Network
  private func fetchDatas(reviewDetail: PublishRelay<ReviewDetail>, disposeBag: DisposeBag) {
    self.fetchKeywordsUseCase?.execute()
      .subscribe { [weak self] result in
        self?.keywords = result
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
    if self.reviewIdx != 0 {
      self.fetchReviewDetailUseCase?.execute(reviewIdx: reviewIdx)
        .subscribe { result in
          Log(result)
          reviewDetail.accept(result)
        } onError: { error in
          Log(error)
        }
        .disposed(by: disposeBag)
    }
  }
  
  private func registerReview(disposeBag: DisposeBag) {
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
                                     access: self.newReviewDetail.access)
    
    Log(perfumeReview)
    
    if self.reviewIdx == 0 {
      self.addReviewUseCase?.execute(perfumeIdx: self.perfumeDetail!.perfumeIdx, perfumeReview: perfumeReview)
        .subscribe(onNext: { [weak self] _ in
          self?.coordinator?.finishFlow?()
        }, onError: { error in
          Log(error)
        })
        .disposed(by: disposeBag)
    } else {
      self.updateReviewUseCase?.execute(reviewDetail: perfumeReview)
        .subscribe(onNext: { [weak self] _ in
          self?.coordinator?.finishFlow?()
        }, onError: { error in
          Log(error)
        })
        .disposed(by: disposeBag)
    }
  }
  
  private func checkRegister(detail: ReviewDetail?, showToast: PublishRelay<Void>, disposeBag: DisposeBag) {
    guard let detail = detail else { return }
    if detail.access {
      if detail.longevity == -1 || detail.sillage == -1 || detail.keywords.isEmpty || detail.gender == -1 || detail.seasonal.isEmpty {
        showToast.accept(())
        return
      }
    }
    
    self.registerReview(disposeBag: disposeBag)
  }
  
  // Review 가 존재할때 초기 세팅
  private func setReviewDetail(output: Output,
                               reviewDetail: ReviewDetail,
                               keywords: BehaviorRelay<[Keyword]>,
                               longevities: BehaviorRelay<[Longevity]>,
                               sillages: BehaviorRelay<[Sillage]>,
                               seasonals: BehaviorRelay<[Seasonal]>,
                               genders: BehaviorRelay<[Gender]>,
                               isShareButtonSelected: BehaviorRelay<Bool>,
                               canDone: PublishRelay<Bool>,
                               canUpdate: PublishRelay<Bool>,
                               disposeBag: DisposeBag) {
    
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
    isShareButtonSelected.accept(reviewDetail.access)
    
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
    if updatedIdx == 1 || updatedIdx == 3 {
      return sillages
    }
    self.newReviewDetail.sillage = updatedIdx / 2
    self.checkChange(canUpdate: canUpdate)
    return sillages.enumerated().map { idx, sillage in
      Sillage(sillage: sillage.sillage, percent: sillage.percent, isAccent: updatedIdx == idx)
    }
  }
  
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
    let indice = getSeasonalIdx(newSeasonals)
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
  
  private func gendersUpdated(updatedIdx: Int, genders: [Gender], canUpdate: PublishRelay<Bool>) -> [Gender] {
    if updatedIdx == 1 || updatedIdx == 3 {
      return genders
    }
    self.newReviewDetail.gender = updatedIdx / 2
    self.checkChange(canUpdate: canUpdate)
    return genders.enumerated().map { idx, gender in
      Gender(gender: gender.gender, percent: gender.percent, color: gender.color, isAccent: updatedIdx == idx)
    }
  }
  
  private func getSeasonalIdx(_ newSeasonals: [String]) -> [Int] {
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
  
}

extension PerfumeReviewViewModel: BottomSheetDismissDelegate {
  func setKeywordsFromBottomSheet(keywords: [Keyword]) {
    self.bottomSheetInput.keywords.accept(keywords)
  }
}

extension PerfumeReviewViewModel: LabelPopupDelegate {
  func confirm() {
    Log(self.reviewIdx)
    self.deleteReviewUseCase?.execute(reviewIdx: self.reviewIdx)
      .subscribe(onNext: { [weak self] a in
        Log(a)
        self?.coordinator?.finishFlow?()
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
}
