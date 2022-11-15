//
//  PerfumeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import Foundation

final class PerfumeDetailViewModel {
  
  private weak var coordinator: PerfumeDetailCoordinator?
  private var perfumeRepository: PerfumeRepository
  private var perfumeIdx: Int
  
  init(coordinator: PerfumeDetailCoordinator, perfumeRepository: PerfumeRepository, perfumeIdx: Int) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.perfumeIdx = perfumeIdx
  }
}
