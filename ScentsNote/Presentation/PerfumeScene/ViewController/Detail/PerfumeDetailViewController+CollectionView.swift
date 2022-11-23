//
//  PerfumeDetailViewController+CollectionView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit

extension PerfumeDetailViewController {
  func getTitleSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(532))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(532))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .top)
    
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  func getContentSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(800))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
//    group.interItemSpacing = .fixed(8)

//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000))
//    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
//    section.orthogonalScrollingBehavior = .groupPaging
//    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .groupPaging

    return section
  }
  
}


