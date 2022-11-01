//
//  SurveySeriesView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit

class SurveySeriesView: UICollectionView {
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
}

private extension SurveySeriesView {
  func configureUI() {
    self.collectionViewLayout = self.createCompositionalLayout()
    self.register(SurveySeriesCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SurveySeriesCollectionViewCell.self))
    
  }
  
  func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1 / 3.0),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(166)
      ),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .none
    
//    let config = UICollectionViewCompositionalLayoutConfiguration()
//    config.scrollDirection = .horizontal
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
