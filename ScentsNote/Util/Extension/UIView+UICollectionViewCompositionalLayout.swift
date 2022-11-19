//
//  UIView+UICollectionViewCompositionalLayout.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit

extension UIView {
  
  /// PerfumeDetail 노트, 부향률, 가격 cell layout
  func perfumeDetailCommonCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(42))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
    let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

    let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
    return UICollectionViewCompositionalLayout(section: layoutSection)
  }
}
