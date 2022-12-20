//
//  FetchKeywordsUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/04.
//

import RxSwift

final class FetchKeywordsUseCase {
  private let keywordRepository: KeywordRepository
  private let disposeBag = DisposeBag()
  
  init(keywordRepository: KeywordRepository) {
    self.keywordRepository = keywordRepository
  }
  
  func execute() -> Observable<[Keyword]> {
    return self.keywordRepository.fetchKeywords()
  }
}
