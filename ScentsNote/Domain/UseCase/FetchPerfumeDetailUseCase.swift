//
//  FetchPerfumeDetailUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import Foundation

final class DefaultFetchPerfumeDetailUseCase {
  
  private let perfumeRepository: PerfumeRepository
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute() { }
}
