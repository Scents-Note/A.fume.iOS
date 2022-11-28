//
//  SearchFilterViewController+CollectionViewLayout.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit

extension SearchFilterViewController {
  func tabCompositionalLayout() -> UICollectionViewCompositionalLayout {
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(KeywordCell.height))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
