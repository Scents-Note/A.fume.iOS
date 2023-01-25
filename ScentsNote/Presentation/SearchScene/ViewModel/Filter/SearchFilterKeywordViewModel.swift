//
//  SearchFilterKeywordViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/24.
//

import RxSwift
import RxRelay

final class SearchFilterKeywordViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let keywordCellDidTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let keywordDataSource = BehaviorRelay<[FilterKeywordDataSection.Model]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var filterDelegate: FilterDelegate?
  private let fetchKeywordsUseCase: FetchKeywordsUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var keywords: [Keyword] = []
  
  // MARK: - Life Cycle
  init(filterDelegate: FilterDelegate,
       fetchKeywordsUseCase: FetchKeywordsUseCase) {
    self.filterDelegate = filterDelegate
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let keywords = PublishRelay<[Keyword]>()
    let keywordSelected = PublishRelay<Int>()
    
    self.bindInput(input: input,
                   keywords: keywords,
                   keywordSelected: keywordSelected)
    
    self.bindOutput(output: output,
                    keywords: keywords)
    
    self.fetchDatas(keywords: keywords)
  }
  
  private func bindInput(input: Input,
                         keywords: PublishRelay<[Keyword]>,
                         keywordSelected: PublishRelay<Int>) {
    
    input.keywordCellDidTapEvent.withLatestFrom(keywords) { [weak self] idx, originals in
      return self?.keywordsUpdated(keywordIdx: idx, keywords: originals) ?? []
    }
    .bind(to: keywords)
    .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output,
                          keywords: PublishRelay<[Keyword]>) {
    
    keywords.withLatestFrom(output.keywordDataSource) { updated, originals in
          let items = updated.map { FilterKeywordDataSection.Item(keyword: $0) }
          let sectionModel = FilterKeywordDataSection.Model(model: "keyword", items: items)
          return [sectionModel]
        }
        .bind(to: output.keywordDataSource)
        .disposed(by: self.disposeBag)

  }
  
  private func fetchDatas(keywords: PublishRelay<[Keyword]>) {
    self.fetchKeywordsUseCase.execute()
      .bind(to: keywords)
      .disposed(by: self.disposeBag)
  }
  
  private func updateKeywords(keyword: Keyword, isSelected: Bool) {
    if isSelected {
      self.keywords = self.keywords.filter { $0.idx != keyword.idx }
    } else {
      self.keywords += [keyword]
    }
    self.filterDelegate?.updateKeywords(keywords: self.keywords)
  }
  
  // TODO: Get Keyword 함수 안에 필드 변수 updateKeyword 함수가 들어가 있는게 괜찮은 방식인가..?
  private func keywordsUpdated(keywordIdx: Int, keywords: [Keyword]) -> [Keyword] {
    var updated = keywords
    for (idx, _) in keywords.enumerated() {
      if idx == keywordIdx {
        let isSelected = updated[idx].isSelected
        if !isSelected, self.keywords.count == 5 {
          break
        }
        self.updateKeywords(keyword: keywords[idx], isSelected: isSelected)
        updated[idx].isSelected = !isSelected
        break
      }
    }
    return updated
  }

}
