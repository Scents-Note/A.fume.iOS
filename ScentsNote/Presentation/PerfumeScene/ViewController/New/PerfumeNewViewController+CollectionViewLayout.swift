//
//  PerfumeNewViewController+CollectionViewLayout.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit

extension PerfumeNewViewController {
  func gridCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let imageHeight = UIScreen.main.bounds.width / 2 - 27.5
    let brandNameOffset: CGFloat = 10
    let brandNameHeight: CGFloat = 18
    let nameHeight: CGFloat = 24
    let height: CGFloat = imageHeight + brandNameOffset + brandNameHeight + brandNameHeight + nameHeight
    let fraction: CGFloat = 1 / 2
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12.5, bottom: 0, trailing: 12.5)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 11.5, leading: 0, bottom: 0, trailing: 0)
    section.interGroupSpacing = 16
    section.boundarySupplementaryItems = [header]
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
