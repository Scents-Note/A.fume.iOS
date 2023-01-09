//
//  SearchViewController+CollectionViewLayout.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit

extension SearchViewController {
  func gridCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let imageHeight = UIScreen.main.bounds.width / 2 - 27.5
    let brandNameOffset: CGFloat = 10
    let brandNameHeight: CGFloat = 18
    let nameHeight: CGFloat = 24
    let height: CGFloat = imageHeight + brandNameOffset + brandNameHeight + nameHeight
    let fraction: CGFloat = 1 / 2
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12.5, bottom: 0, trailing: 12.5)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 70, trailing: 0)
    section.interGroupSpacing = 16
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

