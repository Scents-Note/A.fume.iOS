//
//  DefaultKeywordRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxSwift

final class DefaultKeywordRepository: KeywordRepository {
  
  private let keywordService: KeywordService
  
  init(keywordService: KeywordService){
    self.keywordService = keywordService
  }
  
  func fetchKeywords() -> Observable<[Keyword]> {
    self.keywordService.fetchKeywords()
      .map { $0.rows.map { $0.toDomain()} }
  }
}
