//
//  KeywordService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxSwift

protocol KeywordService {
  func fetchKeywords() -> Observable<ListInfo<KeywordResponseDTO>>
}
