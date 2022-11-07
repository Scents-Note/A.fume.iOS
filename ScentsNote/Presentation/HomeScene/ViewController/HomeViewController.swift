//
//  HomeViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class HomeViewController: UIViewController {
  var viewModel: HomeViewModel?
  private let disposeBag = DisposeBag()
  
  // MARK: - Properties
  private let sections: [HomeSection] = [.title, .recommendation, .popularity]
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
      let section = self.sections[section]
      switch section {
      case .title:
        return self.getHomeTitleSection()
      case .recommendation:
        return self.getHomeRecommendationSection()
      case .popularity:
        return self.getHomePopularitySection()
      default:
        return self.getHomeRecommendationSection()
      }
    }
  ).then {
    $0.isScrollEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = true
    $0.contentInset = .zero
    $0.backgroundColor = .clear
    $0.clipsToBounds = true
    $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(HomeTitleSection.self)
    $0.register(HomeRecommendationSection.self)
    $0.register(HomePopularityCell.self)
    $0.dataSource = self
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
}

extension HomeViewController {
  
  private func configureUI() {
    //    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.bottom.equalToSuperview()
    }
    //    self.collectionView.reloadData()
  }
  
  private func bindViewModel() {
    let input = HomeViewModel.Input()
    
    let output = viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindPersonalPerfume(output: output)
  }
  
  private func bindPersonalPerfume(output: HomeViewModel.Output?) {
    output?.loadData
      .subscribe(onNext: { [weak self] _ in
        print("User Log: ue")
        self?.collectionView.reloadData()
      })
      .disposed(by: disposeBag)
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
    section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 0)

    //    section.orthogonalScrollingBehavior = .continuous
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
      heightDimension: .estimated(112)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    //    group.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 100, bottom: 12, trailing: 8)
    
    // section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 23, leading: 0, bottom: 36, trailing: 0)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  private func getHomePopularitySection() -> NSCollectionLayoutSection {
    // item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    // group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(166),
      heightDimension: .estimated(198)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    group.interItemSpacing = .fixed(8)
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(90)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    
    
    // section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 23, leading: 0, bottom: 0, trailing: 20)
    //    section.contentInsetsReference = .layoutMargins
    //    section.contentInsetsReference = .layoutMargins
    
    section.boundarySupplementaryItems = [header]
    
    return section
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if self.sections[section] == .title || self.sections[section] == .recommendation || self.sections[section] == .more {
      return 1
    } else if self.sections[section] == .popularity {
      return viewModel?.perfumesPopular.count ?? 0
    }
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let section = self.sections[indexPath.section]
    switch section {
    case .title:
      let cell = collectionView.dequeueReusableCell(HomeTitleSection.self, for: indexPath)
      return cell
    case .recommendation:
      let cell = collectionView.dequeueReusableCell(HomeRecommendationSection.self, for: indexPath)
      cell.updateUI(perfumes: self.viewModel?.perfumesRecommended)
      return cell
    case .popularity:
      let cell = collectionView.dequeueReusableCell(HomePopularityCell.self, for: indexPath)
      cell.updateUI(perfume: self.viewModel?.perfumesPopular[indexPath.row])
      return cell
    default:
      return UICollectionViewCell()
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableHeaderView(HomeHeaderView.self, for: indexPath)
      switch self.sections[indexPath.section] {
      case .recommendation:
        header.updateUI(title: "000 님을 위한\n향수 추천", content: "어퓸을 사용할수록\n더 잘 맞는 향수를 보여드려요")
      case .popularity:
        header.updateUI(title: "20대 여성이\n많이 찾는 향수", content: "00 님 연령대 분들에게 인기 많은 향수 입니다.")
      default:
        break
      }
      return header
    default:
      return UICollectionReusableView()
    }
  }
  //  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
  //    return UIEdgeInsets(top: 25, left: 100, bottom: 0, right: 5)
  //  }
}
