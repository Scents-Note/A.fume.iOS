//
//  HomeViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

import SnapKit
import Then

private enum SupplementaryKind {
    static let header = "header-element-kind"
    static let footer = "footer-element-kind"
}


final class HomeViewController: UIViewController {
  
  let dummy = [Perfume(perfumeIdx: 1, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false), Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false)]
  
  var viewModel: HomeViewModel?
  private let disposeBag = DisposeBag()

  
  // MARK: - Properties
  private let sections: [HomeDataSection.HomeSection] = [.title, .recommendation, .popularity, .recent, .new, .more]
  
  
  //  private var collectionView = UICollectionView()
  private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
    let section = self.sections[section]
    switch section {
    case .title:
      return self.getHomeTitleSection()
    case .recommendation:
      return self.getHomeRecommendationSection()
    case .popularity:
      return self.getHomePopularitySection()
    case .recent:
      return self.getHomeRecentSection()
    case .new:
      return self.getHomeNewSection()
    case .more:
      return self.getHomeMoreSection()
    }
  }.then {
    $0.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background-lightGray")
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout).then {
    $0.isScrollEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = true
    $0.contentInset = .zero
    $0.backgroundColor = .clear
    $0.clipsToBounds = true
    $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(HomeTitleCell.self)
    $0.register(HomeRecommendationSection.self)
    $0.register(HomePopularityCell.self)
    $0.register(HomeRecentCell.self)
    $0.register(HomeNewCell.self)
    $0.register(HomeMoreCell.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
    
    self.bind()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
 
}

extension HomeViewController {
  
  func bind() {
    let dataSource = RxCollectionViewSectionedReloadDataSource<HomeDataSection.Model>(
      configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case .title:
          let cell = self.collectionView.dequeueReusableCell(HomeTitleCell.self, for: indexPath)
          return cell
        case .recommendation(let perfumes):
          let cell = self.collectionView.dequeueReusableCell(HomeRecommendationSection.self, for: indexPath)
          cell.updateUI(perfumes: perfumes)
          return cell
        case .popularity(let perfume):
          let cell = self.collectionView.dequeueReusableCell(HomePopularityCell.self, for: indexPath)
          cell.updateUI(perfume: perfume)
          return cell
        case .recent(let perfume):
          let cell = self.collectionView.dequeueReusableCell(HomeRecentCell.self, for: indexPath)
          cell.updateUI(perfume: perfume)
          return cell
        case .new(let perfume):
          let cell = self.collectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
          cell.updateUI(perfume: perfume)
          return cell
        case .more:
          let cell = self.collectionView.dequeueReusableCell(HomeMoreCell.self, for: indexPath)
          return cell
        }
    })
    
    dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
       if kind == UICollectionView.elementKindSectionHeader {
         let section = collectionView.dequeueReusableHeaderView(HomeHeaderView.self, for: indexPath)
         switch self.sections[indexPath.section] {
         case .recommendation:
           section.updateUI(title: "000 님을 위한\n향수 추천", content: "어퓸을 사용할수록\n더 잘 맞는 향수를 보여드려요")
         case .popularity:
           section.updateUI(title: "20대 여성이\n많이 찾는 향수", content: "00 님 연령대 분들에게 인기 많은 향수 입니다.")
         case .recent:
           section.updateUI(title: "최근 찾아본 향수", content: nil)
         case .new:
           section.updateUI(title: "새로\n등록된 향수", content: "기대하세요.  새로운 향수가 업데이트 됩니다.")
         default:
           break
         }
         return section
    
       } else {
         return UICollectionReusableView()
       }
    }
    
    self.viewModel?.subject
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)


//    dataSource.titleForHeaderInSection = { dataSource, index in
//      return dataSource.sectionModels[index].header
//    }
//
//    dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
//      return true
//    }
 
  }
  
  private func configureUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  private func bindViewModel() {
    let input = HomeViewModel.Input(
    )
    
    let output = viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindPersonalPerfume(output: output)
  }
  
  private func bindPersonalPerfume(output: HomeViewModel.Output?) {

  }
}

// MARK: - Section Layout
extension HomeViewController {
  private func getHomeTitleSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(30)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0)
    
    return section
    
  }
  
  private func getHomeRecommendationSection() -> NSCollectionLayoutSection {
    // item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //    item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
    
    // group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(322)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    //    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
    //      leading: .fixed(100),
    //      top: nil,
    //      trailing: nil,
    //      bottom: nil
    //    )
    
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(126)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    // section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 23, leading: 0, bottom: 4, trailing: 0)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  private func getHomePopularitySection() -> NSCollectionLayoutSection {
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(166),
      heightDimension: .estimated(198)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(110)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 23, leading: 0, bottom: 42, trailing: 20)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  private func getHomeRecentSection() -> NSCollectionLayoutSection {
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(128),
      heightDimension: .absolute(157)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(44)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .topLeading
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 12, bottom: 24, trailing: 12)
    section.boundarySupplementaryItems = [header]
    
    let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "background-lightGray")
    section.decorationItems = [sectionBackground]
    
    
    return section
  }
  
  private func getHomeNewSection() -> NSCollectionLayoutSection {
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(0.3)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 2
    )
    
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(110)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 0, bottom: 0, trailing: 20)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  private func getHomeMoreSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(48)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 48, trailing: 20)
    
    return section
    
  }
}

