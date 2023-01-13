//
//  DefaultKeywordRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxSwift

final class DefaultKeywordRepository: KeywordRepository {
  
  static let shared: DefaultKeywordRepository = DefaultKeywordRepository(keywordService: DefaultKeywordService.shared)
  
  private let keywordService: KeywordService
  
  private init(keywordService: KeywordService){
    self.keywordService = keywordService
  }
  
  func fetchKeywords() -> Observable<[Keyword]> {
    self.keywordService.fetchKeywords()
      .map { $0.rows.map { $0.toDomain()} }
  }
}
