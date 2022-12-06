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
  }
  
  struct Output {
    let perfumeReview = BehaviorRelay<ReviewDetail?>(value: nil)
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
  private let fetchKeywordsUseCase: FetchKeywordsUseCase
  private let fetchReviewInMyPageUseCase: FetchReviewInMyPageUseCase?
  private let addReviewUseCase: AddReviewUseCase?
  private let updateReviewUseCase: UpdateReviewUseCase?
  
  private let perfumeDetail: PerfumeDetail?
  private var reviewIdx: Int = 0
  private var keywords: [Keyword] = []
  private let bottomSheetInput = BottomSheetInput()
  
  // Vars for Request
  private var score: Double = 0
  private var note: String = ""
  private var longevityIdx: Int? = nil
  private var sillageIdx: Int? = nil
  private var seasonals: [String] = []
  private var genderIdx: Int? = nil
  private var isAccessable: Bool = false
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeReviewCoordinator,
       perfumeDetail: PerfumeDetail,
       fetchKeywordsUseCase: FetchKeywordsUseCase,
       addReviewUseCase: AddReviewUseCase) {
    self.coordinator = coordinator
    self.perfumeDetail = perfumeDetail
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    self.addReviewUseCase = addReviewUseCase
  }
  
  init(coordinator: PerfumeReviewCoordinator,
       reviewIdx: Int,
       fetchKeywordsUseCase: FetchKeywordsUseCase,
       addReviewUseCase: AddReviewUseCase) {
    self.coordinator = coordinator
    self.reviewIdx = reviewIdx
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    self.updateReviewUseCase = updateReviewUseCase
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
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
                    keywords: keywords,
                    longevities: longevities,
                    sillages: sillages,
                    seasonals: seasonals,
                    genders: genders,
                    isShareButtonSelected: isShareButtonSelected,
                    canDone: canDone,
                    disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
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
        self?.score = score
      })
      .disposed(by: disposeBag)
    
    input.noteTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.note = text
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
      self.longevityIdx = updatedIdx
      return self.longevitiesUpdated(updatedIdx: updatedIdx, longevities: originals)
    }
    .bind(to: longevities)
    .disposed(by: disposeBag)
    
    input.sillageCellDidTapEvent.withLatestFrom(sillages) { [weak self] updatedIdx, originals in
      guard let self = self else { return originals }
      self.sillageIdx = updatedIdx / 2
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
      self.genderIdx = updatedIdx
      return self.gendersUpdated(updatedIdx: updatedIdx, genders: originals)
    }
    .bind(to: genders)
    .disposed(by: disposeBag)
    
    input.shareButtonDidTapEvent
      .subscribe(onNext: {
        self.isAccessable = !isShareButtonSelected.value
        isShareButtonSelected.accept(!isShareButtonSelected.value)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
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
  
  private func fetchDatas(disposeBag: DisposeBag) {
    self.fetchKeywordsUseCase.execute()
      .subscribe { [weak self] keywords in
        self?.keywords = keywords
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
    
    if self.reviewIdx != 0 {
      self.fe
    }
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
    longevities.enumerated().map { idx, longevity in
      Longevity(longevity: longevity.longevity, duration: longevity.duration, percent: longevity.percent, isAccent: updatedIdx == idx)
    }
  }
  private func sillagesUpdated(updatedIdx: Int, sillages: [Sillage]) -> [Sillage] {
    if updatedIdx == 1 || updatedIdx == 3 {
      return sillages
    }
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
    self.seasonals = updatedSeasonals.filter { $0.isAccent }.map { $0.season }
    return updatedSeasonals
  }
  
  private func gendersUpdated(updatedIdx: Int, genders: [Gender]) -> [Gender] {
    genders.enumerated().map { idx, gender in
      Gender(gender: gender.gender, percent: gender.percent, isAccent: updatedIdx == idx)
    }
  }
  
  private func registerReview(disposeBag: DisposeBag) {
    let selectedKeywords = self.keywords.filter { $0.isSelected }
    
    let perfumeReview = ReviewDetail(score: self.score,
                                      sillage: self.sillageIdx,
                                      longevity: self.longevityIdx,
                                      seasonal: self.seasonals,
                                      gender: self.genderIdx,
                                      content: self.note,
                                      Perfume: nil,
                                      keywords: selectedKeywords,
                                      Brand: nil,
                                      access: self.isAccessable)
    self.addReviewUseCase.execute(perfumeIdx: self.perfumeDetail!.perfumeIdx, perfumeReview: perfumeReview)
      .subscribe(onNext: { [weak self] _ in
        self?.coordinator?.finishFlow?()
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
  }
  
 
}

extension PerfumeReviewViewModel: BottomSheetDismissDelegate {
  func setKeywordsFromBottomSheet(keywords: [Keyword]) {
    self.bottomSheetInput.keywords.accept(keywords)
  }
}
