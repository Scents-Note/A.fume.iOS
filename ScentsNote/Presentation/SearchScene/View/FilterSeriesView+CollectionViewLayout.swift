//
//  FilterSeriesView+CollectionViewLayout.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import UIKit

extension FilterSeriesView {
  func compositionalLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(86), heightDimension: .absolute(42))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
    let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

    layoutGroup.interItemSpacing = .fixed(16)
    let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
    layoutSection.contentInsets = .init(top: 24, leading: 20, bottom: 24, trailing: 20)
    layoutSection.interGroupSpacing = 16
    
    return UICollectionViewCompositionalLayout(section: layoutSection)
  }
  
//  func compositionalLayout() -> UICollectionViewCompositionalLayout {
//    
//    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(KeywordCell.height))
//    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//    let section = NSCollectionLayoutSection(group: group)
//    
//    return UICollectionViewCompositionalLayout(section: section)
//  }
}
