//
//  FetchKeywordsUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/04.
//

import RxSwift

protocol FetchKeywordsUseCase {
  func execute() -> Observable<[Keyword]>
}

final class DefaultFetchKeywordsUseCase: FetchKeywordsUseCase {
  private let keywordRepository: KeywordRepository
  private let disposeBag = DisposeBag()
  
  init(keywordRepository: KeywordRepository) {
    self.keywordRepository = keywordRepository
  }
  
  func execute() -> Observable<[Keyword]> {
    return self.keywordRepository.fetchKeywords()
  }
}
