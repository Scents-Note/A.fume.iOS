//
//  SurveySeriesView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/03.
//

import UIKit

class SurveySeriesView: UICollectionView {
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

private extension SurveySeriesView {
  func configureUI() {
    self.collectionViewLayout = self.createCompositionalLayout()
    self.register(SurveySeriesCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SurveySeriesCollectionViewCell.self))
    self.backgroundColor = .lightGray
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
        heightDimension: .absolute(SurveySeriesCollectionViewCell.height)
      ),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 24, leading: 0, bottom: 24, trailing: 0)
    section.orthogonalScrollingBehavior = .none
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
