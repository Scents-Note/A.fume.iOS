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
    let keywordTextFieldDidEditEvent: Observable<String>
    let searchButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let finish = BehaviorRelay<Bool>(value: false)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: SearchKeywordCoordinator?
  var perfumeRepository: PerfumeRepository
  
  // MARK: - Life Cycle
  init(coordinator: SearchKeywordCoordinator, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    var searchWord = ""
    
    input.keywordTextFieldDidEditEvent
      .subscribe(onNext: { text in
        searchWord = text
      })
      .disposed(by: disposeBag)
    
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        let perfumeSearch = PerfumeSearch(searchWord: searchWord)
        output.finish.accept(true)
        self?.coordinator?.finishFlow?(perfumeSearch)
      })
      .disposed(by: disposeBag)
    
    self.bindOutput(output: output, disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
    return output
  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    
  }
  
  private func fetchDatas(disposeBag: DisposeBag) {
    
  }
}
