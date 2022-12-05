//
//  FetchKeywordsUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/04.
//

import RxSwift

final class FetchKeywordsUseCase {
  private let repository: KeywordRepository
  private let disposeBag = DisposeBag()
  
  init(repository: KeywordRepository) {
    self.repository = repository
  }
  
  func execute() -> Observable<[Keyword]> {
    return self.repository.fetchKeywords()
  }
}
