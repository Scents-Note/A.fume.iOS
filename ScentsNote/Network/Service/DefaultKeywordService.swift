//
//  DefaultKeywordService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxSwift

final class DefaultKeywordService: ScentsNoteService, KeywordService {
  
  static let shared: DefaultKeywordService = DefaultKeywordService()
  private override init() {}

  func fetchKeywords() -> Observable<ListInfo<KeywordResponseDTO>> {
    requestObject(.fetchKeywords)
  }
}
