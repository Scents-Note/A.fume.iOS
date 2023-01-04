//
//  KeywordBottomSheetViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/03.
//

import Foundation

import RxSwift
import RxRelay

final class KeywordBottomSheetViewModel {
  
  enum State {
    case fill
    case half
  }
  
  // MARK: - Input & Output
  struct CellInput {
    let keywordCellDidTapEvent = PublishRelay<Keyword>()
  }
  
  struct ScrollInput {
    let hideBottomSheetEvent = PublishRelay<Void>()
  }
  
  struct Input {
    let confirmButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let keywords = BehaviorRelay<[FilterKeywordDataSection.Model]>(value: [])
    let hideBottomSheet = PublishRelay<Bool>()
  }
  
  // MARK: - Vars & Lets
  weak var delegate: BottomSheetDismissDelegate?
  weak var coordinator: PerfumeReviewCoordinator?

  var state: State = .half
  var cellInput = CellInput()
  var keywords: [Keyword] = []
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeReviewCoordinator, delegate: BottomSheetDismissDelegate, keywords: [Keyword]) {
    self.coordinator = coordinator
    self.delegate = delegate
    self.keywords = keywords
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let keywords = BehaviorRelay<[Keyword]>(value: [])
    let keyword = PublishRelay<Keyword>()
    let close = PublishRelay<Bool>()
    
    self.bindInput(input: input,
                   keywords: keywords,
                   close: close,
                   disposeBag: disposeBag)
    
    self.bindCellInput(input: self.cellInput,
                       keyword: keyword,
                       keywords: keywords,
                       disposeBag: disposeBag)
    
    self.bindOutput(output: output,
                    keywords: keywords,
                    close: close,
                    disposeBag: disposeBag)
    self.fetchDatas(keywords: keywords, disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input,
                         keywords: BehaviorRelay<[Keyword]>,
                         close: PublishRelay<Bool>,
                         disposeBag: DisposeBag) {
    
    input.confirmButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        close.accept(true)
        self?.updateKeywords(keywords: keywords.value)
      })
      .disposed(by: disposeBag)

  }
  
  private func bindCellInput(input: CellInput,
                             keyword: PublishRelay<Keyword>,
                             keywords: BehaviorRelay<[Keyword]>,
                             disposeBag: DisposeBag) {
    
    input.keywordCellDidTapEvent.withLatestFrom(keywords) { updated, originals in
      return originals.map { original in
        guard original.idx != updated.idx else {
          return Keyword(idx: updated.idx, name: updated.name, isSelected: !updated.isSelected)
        }
        return original
      }
    }
    .bind(to: keywords)
    .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          keywords: BehaviorRelay<[Keyword]>,
                          close: PublishRelay<Bool>,
                          disposeBag: DisposeBag) {
    keywords.withLatestFrom(output.keywords) { updated, originals in
      let items = updated.map { FilterKeywordDataSection.Item(keyword: $0) }
      let sectionModel = FilterKeywordDataSection.Model(model: "keyword", items: items)
      return [sectionModel]
    }
    .bind(to: output.keywords)
    .disposed(by: disposeBag)
    
    close
      .subscribe(onNext: { _ in
        output.hideBottomSheet.accept(true)
      })
      .disposed(by: disposeBag)

  }
  
  private func fetchDatas(keywords: BehaviorRelay<[Keyword]>,
                          disposeBag: DisposeBag) {
    keywords.accept(self.keywords)
  }
  
  func setState(state: State) {
    self.state = state
  }
  
  func updateKeywords(keywords: [Keyword]) {
    self.delegate?.setKeywordsFromBottomSheet(keywords: keywords)
  }
}


protocol BottomSheetDismissDelegate: AnyObject {
  func setKeywordsFromBottomSheet(keywords: [Keyword])
}
