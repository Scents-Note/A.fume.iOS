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
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: PerfumeReviewCoordinator?
  private var fetchKeywordsUseCase: FetchKeywordsUseCase?
  private var fetchReviewDetailUseCase: FetchReviewDetailUseCase?
  private var addReviewUseCase: AddReviewUseCase?
  private var updateReviewUseCase: UpdateReviewUseCase?
  
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
  }
  
  /// 작성한 리뷰가 있을때
  init(coordinator: PerfumeReviewCoordinator,
       reviewIdx: Int,
       fetchReviewDetailUseCase: FetchReviewDetailUseCase,
       updateReviewUseCase: UpdateReviewUseCase,
       fetchKeywordsUseCase: FetchKeywordsUseCase) {
    self.coordinator = coordinator
    self.reviewIdx = reviewIdx
    self.fetchReviewDetailUseCase = fetchReviewDetailUseCase
    self.updateReviewUseCase = updateReviewUseCase
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
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
    
    self.bindInput(input: input,
                   bottomSheetInput: bottomSheetInput,
                   keywords: keywords,
                   longevities: longevities,
                   sillages: sillages,
                   seasonals: seasonals,
                   genders: genders,
                   isShareButtonSelected: isShareButtonSelected,
                   canDone: canDone,
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
                         disposeBag: DisposeBag) {
    
    input.imageContainerDidTapEvent
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.finishFlow?()
      })
      .disposed(by: disposeBag)
    
    input.starViewDidUpdateEvent
      .subscribe(onNext: { [weak self] score in
        self?.newReviewDetail.score = score
      })
      .disposed(by: disposeBag)
    
    input.noteTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.newReviewDetail.content = text
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
    
    input.keywordAddButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.coordinator?.showKeywordBottomSheetViewController(keywords: self.keywords)
      })
      .disposed(by: disposeBag)
    
    input.longevityCellDidTapEvent.withLatestFrom(longevities) { [weak self] updatedIdx, originals in
      guard let self = self else { return originals }
      return self.longevitiesUpdated(updatedIdx: updatedIdx, longevities: originals)
    }
    .bind(to: longevities)
    .disposed(by: disposeBag)
    
    input.sillageCellDidTapEvent.withLatestFrom(sillages) { [weak self] updatedIdx, originals in
      guard let self = self else { return originals }
      return self.sillagesUpdated(updatedIdx: updatedIdx, sillages: originals)
    }
    .bind(to: sillages)
    .disposed(by: disposeBag)
    
    input.seasonalCellDidTapEvent.withLatestFrom(seasonals) { [weak self] updatedIdx, originals in
      guard let self = self else { return originals }
      return self.seasonalUpdated(updatedIdx: updatedIdx, seasonals: originals)
    }
    .bind(to: seasonals)
    .disposed(by: disposeBag)
    
    input.genderCellDidTapEvent.withLatestFrom(genders) { [weak self] updatedIdx, originals in
      guard let self = self else { return originals }
      return self.gendersUpdated(updatedIdx: updatedIdx, genders: originals)
    }
    .bind(to: genders)
    .disposed(by: disposeBag)
    
    input.shareButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.newReviewDetail.access = !isShareButtonSelected.value
        isShareButtonSelected.accept(!isShareButtonSelected.value)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.registerReview(disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.updateButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.registerReview(disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    bottomSheetInput.keywords
      .subscribe(onNext: { [weak self] updatedKeywords in
        keywords.accept(updatedKeywords)
        self?.updateKeywords(keywords: updatedKeywords)
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
                          disposeBag: DisposeBag) {
    
    if let perfumeDetail = self.perfumeDetail {
      output.perfumeDetail.accept(perfumeDetail)
    }
    
    reviewDetail
      .subscribe(onNext: { [weak self] reviewDetail in
        self?.updateReviewDetail(output: output,
                                 reviewDetail: reviewDetail,
                                 keywords: keywords,
                                 longevities: longevities,
                                 sillages: sillages,
                                 seasonals: seasonals,
                                 genders: genders,
                                 isShareButtonSelected: isShareButtonSelected,
                                 canDone: canDone,
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
          reviewDetail.accept(result)
          Log(result)
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
  
  // MARK: - Update
  private func updateReviewDetail(output: Output,
                                  reviewDetail: ReviewDetail,
                                  keywords: BehaviorRelay<[Keyword]>,
                                  longevities: BehaviorRelay<[Longevity]>,
                                  sillages: BehaviorRelay<[Sillage]>,
                                  seasonals: BehaviorRelay<[Seasonal]>,
                                  genders: BehaviorRelay<[Gender]>,
                                  isShareButtonSelected: BehaviorRelay<Bool>,
                                  canDone: PublishRelay<Bool>,
                                  disposeBag: DisposeBag) {
    
    let updatedLongevity = self.longevitiesUpdated(updatedIdx: reviewDetail.longevity! - 1, longevities: longevities.value)
    let updatedSillage = self.sillagesUpdated(updatedIdx: 2 * reviewDetail.sillage! - 2, sillages: sillages.value)
    let updatedSeasonal = self.seasonalUpdated(newSeasonals: reviewDetail.seasonal!, seasonals: seasonals.value)
    let updatedGender = self.gendersUpdated(updatedIdx: reviewDetail.gender! - 1, genders: genders.value)
    
    self.newReviewDetail = reviewDetail
    output.reviewDetail.accept(reviewDetail)
    keywords.accept(reviewDetail.keywords)
    longevities.accept(updatedLongevity)
    sillages.accept(updatedSillage)
    seasonals.accept(updatedSeasonal)
    genders.accept(updatedGender)
    isShareButtonSelected.accept(reviewDetail.access)
    
  }
  
  private func updateKeywords(keywords: [Keyword]) {
    keywords.forEach { updated in
      for (idx, original) in self.keywords.enumerated() {
        if original.idx == updated.idx {
          self.keywords[idx].isSelected = true
          break
        }
      }
    }
  }
  
  private func longevitiesUpdated(updatedIdx: Int, longevities: [Longevity]) -> [Longevity] {
    self.newReviewDetail.longevity = updatedIdx + 1
    return longevities.enumerated().map { idx, longevity in
      Longevity(longevity: longevity.longevity, duration: longevity.duration, percent: longevity.percent, isAccent: updatedIdx == idx, isEmpty: longevity.isEmpty)
    }
  }
  
  private func sillagesUpdated(updatedIdx: Int, sillages: [Sillage]) -> [Sillage] {
    if updatedIdx == 1 || updatedIdx == 3 {
      return sillages
    }
    self.newReviewDetail.sillage = updatedIdx / 2 + 1
    return sillages.enumerated().map { idx, sillage in
      Sillage(sillage: sillage.sillage, percent: sillage.percent, isAccent: updatedIdx == idx)
    }
  }
  
  private func seasonalUpdated(updatedIdx: Int, seasonals: [Seasonal]) -> [Seasonal] {
    let updatedSeasonals = seasonals.enumerated().map { idx, seasonal in
      guard idx != updatedIdx else {
        return Seasonal(season: seasonal.season, percent: seasonal.percent, color: seasonal.color, isAccent: !seasonal.isAccent)
      }
      return seasonal
    }
    self.newReviewDetail.seasonal = updatedSeasonals.filter { $0.isAccent }.map { $0.season }
    return updatedSeasonals
  }
  
  private func seasonalUpdated(newSeasonals: [String], seasonals: [Seasonal]) -> [Seasonal] {
    let indice = getSeasonalIdx(newSeasonals)
    let updatedSeasonals = seasonals.enumerated().map { idx, seasonal in
      guard !indice.contains(idx) else {
        return Seasonal(season: seasonal.season, percent: seasonal.percent, color: seasonal.color, isAccent: true)
      }
      return seasonal
    }
    self.newReviewDetail.seasonal = updatedSeasonals.filter { $0.isAccent }.map { $0.season }
    return updatedSeasonals
  }
  
  private func gendersUpdated(updatedIdx: Int, genders: [Gender]) -> [Gender] {
    self.newReviewDetail.gender = updatedIdx + 1
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
