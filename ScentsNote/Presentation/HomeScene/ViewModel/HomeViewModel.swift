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
  var perfumesRecent = [Perfume]()
  var perfumesNew = [Perfume]()
  
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
        output.loadData.accept(true)
      }
    }
    
    self.perfumeRepository.fetchRecentPerfumes { result in
      result.success { [weak self] perfumeInfo in
//        self?.perfumesRecent = perfumeInfo?.rows ?? []
        self?.perfumesRecent =  [Perfume(perfumeIdx: 1, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false), Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false)]
        output.loadData.accept(true)
      }
    }
    
    self.perfumeRepository.fetchNewPerfumes { result in
      result.success { [weak self] perfumeInfo in
        self?.perfumesNew = perfumeInfo?.rows ?? []
        print("User Log: self.pe \(self?.perfumesNew)")
        output.loadData.accept(true)
      }
    }
    
    return output
  }

}
