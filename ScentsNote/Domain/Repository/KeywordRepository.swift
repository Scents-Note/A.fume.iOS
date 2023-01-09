//
//  KeywordRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxSwift

protocol KeywordRepository {
  func fetchKeywords() -> Observable<[Keyword]>
}
