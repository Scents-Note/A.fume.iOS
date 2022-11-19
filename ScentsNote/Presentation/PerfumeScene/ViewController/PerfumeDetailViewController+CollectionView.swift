//
//  PerfumeDetailViewController+CollectionView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit

extension PerfumeDetailViewController {
  func getTitleSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(532)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(532)
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
    section.boundarySupplementaryItems = [header]
    
    return section
    
  }
  
  func getContentSection() -> NSCollectionLayoutSection {
    // item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(2000)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //    item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
    
    // group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(2000)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    
    return section
  }
  
}


