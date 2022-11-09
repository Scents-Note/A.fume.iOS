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
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
  var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
  
  let output = Output()
  var subject = BehaviorRelay<[HomeDataSection.Model]>(value: [])
  
  //  ComplexSection.Model(model: .title, items: [ComplexSection.MyItem.title]), ComplexSection.Model(model: .recommendation, items: [ComplexSection.MyItem.recommendation([])])
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
    let perfumes1 = PublishRelay<[Perfume]>()
    let perfumes2 = PublishRelay<[Perfume]>()
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    
    self.perfumeRepository.fetchPerfumesRecommended { result in
      result.success { [weak self] perfumeInfo in
        let myItems3 = HomeDataSection.HomeItem.title
        let mySectionModel3 = HomeDataSection.Model(model: .title, items: [myItems3])
        
        let myItems = HomeDataSection.HomeItem.recommendation(perfumeInfo?.rows ?? [])
        let mySectionModel = HomeDataSection.Model(model: .recommendation, items: [myItems])
        print("User Log: 1)")
        var list = self?.subject.value ?? []
        list.append(contentsOf: [mySectionModel3, mySectionModel])
        
        list.sort { (obj1, obj2) -> Bool in
          return obj1.model.rawValue < obj2.model.rawValue
        }
        
        self?.subject.accept(list)
      }
    }
    
    self.perfumeRepository.fetchPerfumesPopular { result in
      result.success { [weak self] perfumeInfo in
        let myItems = perfumeInfo!.rows.map {HomeDataSection.HomeItem.popularity($0) }
        let mySectionModel = HomeDataSection.Model(model: .popularity, items: myItems)
        
        var list = self?.subject.value ?? []
        list.append(contentsOf: [mySectionModel])
        self?.subject.accept(list)
      }
    }
    
    
    
    self.perfumeRepository.fetchRecentPerfumes { result in
      result.success { [weak self] perfumeInfo in
        
        //        self?.perfumesRecent = perfumeInfo?.rows ?? []
        
      }
    }
    
    let dummyList =  [Perfume(perfumeIdx: 1, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false), Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false)]
    
    let myItems = dummyList.map {HomeDataSection.HomeItem.recent($0) }
    let mySectionModel = HomeDataSection.Model(model: .recent, items: myItems)
    
    var list = self.subject.value ?? []
    list.append(contentsOf: [mySectionModel])
    list.sort { (obj1, obj2) -> Bool in
      return obj1.model.rawValue < obj2.model.rawValue
    }
    self.subject.accept(list)
    
    self.perfumeRepository.fetchNewPerfumes { result in
      result.success { [weak self] perfumeInfo in
        let myItems = perfumeInfo!.rows.map {HomeDataSection.HomeItem.new($0) }
        let mySectionModel = HomeDataSection.Model(model: .new, items: myItems)
        
        let myItems3 = HomeDataSection.HomeItem.more
        let mySectionModel3 = HomeDataSection.Model(model: .more, items: [myItems3])
        
        var list = self?.subject.value ?? []
        list.append(contentsOf: [mySectionModel, mySectionModel3])
        self?.subject.accept(list)
        
      }
    }
    
    return self.output
  }
  
  func onClickPerfumeHeartNew(index: Int) {
    
  }
  
}
