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
  
  var viewModel: HomeViewModel?
  private let disposeBag = DisposeBag()

  
  // MARK: - Properties
  
  var dataSource: RxCollectionViewSectionedReloadDataSource<HomeDataSection.Model>!
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
    self.configureCollectionView()
    self.bindViewModel()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
 
}

// MARK: Configure UI
extension HomeViewController {
  
  private func configureUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  func configureCollectionView() {
    // TODO: 메모리 Leak 나는지 확인해보기
    self.dataSource = RxCollectionViewSectionedReloadDataSource<HomeDataSection.Model>(
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
    
    self.dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
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
  }
  
  
  private func bindViewModel() {
    let input = HomeViewModel.Input(
    )
    
    let output = viewModel?.transform(from: input, disposeBag: disposeBag)
    
    self.bindSection(output: output)
    
    
  }
  
  private func bindSection(output: HomeViewModel.Output?) {
    output?.homeDatas
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}
