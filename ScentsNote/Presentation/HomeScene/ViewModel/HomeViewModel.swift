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
  
  var personalPerfumes = [Perfume]()
  
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
    
    print("hihi")
    
    self.perfumeRepository.fetchPerfumeForIndividual { result in
      result.success { [weak self] perfumeInfo in
        self?.personalPerfumes = perfumeInfo?.rows ?? []
        output.loadData.accept(true)
      }
    }
    
    return output
  }

}
