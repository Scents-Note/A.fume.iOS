//
//  SurveySeriesView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit

class SurveyPerfumeView: UICollectionView {
  
  var clickPerfume: ((IndexPath) -> Void)?
  var perfumes: [Perfume] = []

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
    self.showsVerticalScrollIndicator = false
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
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
        heightDimension: .absolute(SurveyPerfumeCollectionViewCell.height)
      ),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 24, leading: 0, bottom: 24, trailing: 0)
    section.orthogonalScrollingBehavior = .none
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

extension SurveyPerfumeView {
  func setDatas(perfumes: [Perfume]?) {
    guard let perfumes = perfumes else { return }
    self.perfumes = perfumes
    self.reloadData()
  }
  
  func configureUI() {
    self.collectionViewLayout = self.createCompositionalLayout()
    self.translatesAutoresizingMaskIntoConstraints = false
    self.register(SurveyPerfumeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SurveyPerfumeCollectionViewCell.self))
    self.backgroundColor = .lightGray
  }
}
