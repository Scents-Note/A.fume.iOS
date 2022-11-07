//
//  PerfumeRecommandKeywordCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit

class HomeRecommendationKeywordView: UICollectionView {
  
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
    self.showsVerticalScrollIndicator = false
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
}

extension HomeRecommendationKeywordView {
  func configureUI() {
    self.collectionViewLayout = self.createCompositionalLayout()
    self.register(HomeRecommendationKeywordCell.self)
//    self.register(HomeRecommendationKeywordCell.self, forCellWithReuseIdentifier: String(describing: HomeRecommendationKeywordCell.self))
    self.backgroundColor = .lightGray
  }
  
  func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(58), heightDimension: .absolute(26))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
    let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

    layoutGroup.interItemSpacing = .fixed(8)
    let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//    layoutSection.contentInsets = .init(top: 24, leading: 20, bottom: 24, trailing: 20)
//    layoutSection.interGroupSpacing = 16
    
    return UICollectionViewCompositionalLayout(section: layoutSection)
  }
  
//  func updateUI(keywords: [String]?) {
//    print("User Log: keywords \(keywords)")
//    self.keywords = keywords ?? []
//    self.reloadData()
//  }
}

