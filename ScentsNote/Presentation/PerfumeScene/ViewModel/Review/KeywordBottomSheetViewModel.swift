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
  struct Input {
    let keywordCellDidTapEvent = PublishRelay<Keyword>()
    let hideBottomSheetEvent = PublishRelay<Void>()
    let confirmButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let keywords = BehaviorRelay<[FilterKeywordDataSection.Model]>(value: [])
    let hideBottomSheet = PublishRelay<Bool>()
  }
  
  // MARK: - Vars & Lets
  private weak var delegate: BottomSheetDismissDelegate?
  private weak var coordinator: PerfumeReviewCoordinator?
  private let disposeBag = DisposeBag()
  
  let input = Input()
  let output = Output()
  var state: State = .half
  
  var keywords: [Keyword] = []
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeReviewCoordinator, delegate: BottomSheetDismissDelegate, keywords: [Keyword]) {
    self.coordinator = coordinator
    self.delegate = delegate
    self.keywords = keywords

    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let keywords = BehaviorRelay<[Keyword]>(value: self.keywords)
    let close = PublishRelay<Bool>()
    
    self.bindInput(input: input,
                   keywords: keywords,
                   close: close)
    
    self.bindOutput(output: output,
                    keywords: keywords,
                    close: close)
  }
  
  private func bindInput(input: Input,
                         keywords: BehaviorRelay<[Keyword]>,
                         close: PublishRelay<Bool>) {
    
    input.confirmButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        close.accept(true)
        self?.updateKeywords(keywords: keywords.value)
      })
      .disposed(by: self.disposeBag)
    
    input.keywordCellDidTapEvent.withLatestFrom(keywords) { updated, originals in
      return originals.map { original in
        guard original.idx != updated.idx else {
          return Keyword(idx: updated.idx, name: updated.name, isSelected: !updated.isSelected)
        }
        return original
      }
    }
    .bind(to: keywords)
    .disposed(by: self.disposeBag)
  }
  
  
  private func bindOutput(output: Output,
                          keywords: BehaviorRelay<[Keyword]>,
                          close: PublishRelay<Bool>) {
    keywords.map {
      let items = $0.map { FilterKeywordDataSection.Item(keyword: $0) }
      let sectionModel = FilterKeywordDataSection.Model(model: "keyword", items: items)
      return [sectionModel]
    }
    .bind(to: output.keywords)
    .disposed(by: self.disposeBag)
    
    close
      .subscribe(onNext: { _ in
        output.hideBottomSheet.accept(true)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func fetchDatas(keywords: BehaviorRelay<[Keyword]>) {
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
