//
//  HomeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay

final class HomeViewModel {
  weak var coordinator: HomeCoordinator?
  var perfumeRepository: PerfumeRepository
  
  var perfumesRecommended = [Perfume]()
  var perfumesPopular = [Perfume]()
  
  init(coordinator: HomeCoordinator, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
  }
  
  struct Input {

  }
  
  struct Output {
    let loadData = PublishRelay<Bool>()
  }

  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    self.perfumeRepository.fetchPerfumesRecommended { result in
      result.success { [weak self] perfumeInfo in
        self?.perfumesRecommended = perfumeInfo?.rows ?? []
        output.loadData.accept(true)
      }
    }
    
    self.perfumeRepository.fetchPerfumesPopular { result in
      result.success { [weak self] perfumeInfo in
        self?.perfumesPopular = perfumeInfo?.rows ?? []
        print("User Log: per \(self?.perfumesPopular)")
        output.loadData.accept(true)
      }
    }
    
    return output
  }

}
