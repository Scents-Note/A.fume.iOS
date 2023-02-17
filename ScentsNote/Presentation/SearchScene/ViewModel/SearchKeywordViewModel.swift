//
//  SearchKeywordViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import RxSwift
import RxRelay

final class SearchKeywordViewModel {
  // MARK: - Input & Output
  struct Input {
    let keywordTextFieldDidEditEvent = PublishRelay<String>()
    let searchButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let finish = BehaviorRelay<CoordinatorType>(value: .search)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SearchKeywordCoordinator?
  private let from: CoordinatorType
  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()
  var searchWord = ""
  
  // MARK: - Life Cycle
  init(coordinator: SearchKeywordCoordinator, from: CoordinatorType) {
    self.coordinator = coordinator
    self.from = from
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let finish = PublishRelay<CoordinatorType>()
    self.bindInput(input: input, finish: finish)
    self.bindOutput(output: output, finish: finish)
  }
  
  private func bindInput(input: Input, finish: PublishRelay<CoordinatorType>) {
    input.keywordTextFieldDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.searchWord = text
      })
      .disposed(by: self.disposeBag)
    
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        if self?.from == .search {
          finish.accept(self?.from ?? .search)
        }
        let perfumeSearch = PerfumeSearch(searchWord: self?.searchWord)
        self?.coordinator?.finishFlow?(perfumeSearch)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output, finish: PublishRelay<CoordinatorType>) {
    finish
      .bind(to: output.finish)
      .disposed(by: self.disposeBag)
  }
}
