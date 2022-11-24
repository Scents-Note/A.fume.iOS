//
//  SearchResultViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import RxSwift
import RxRelay

final class SearchResultViewModel {
  // MARK: - Input & Output
  struct Input {
  }
  
  struct Output {
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: SearchResultCoordinator?
  var perfumeRepository: PerfumeRepository
  
  // MARK: - Life Cycle
  init(coordinator: SearchResultCoordinator, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(output: output, disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input, disposeBag: DisposeBag) {
    
  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    
  }
  
  private func fetchDatas(disposeBag: DisposeBag) {
    
  }
}
