//
//  SurveySeriesView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit
import Reusable

class SurveyPerfumeView: UICollectionView {
  
  var clickPerfume: ((IndexPath) -> Void)?
  var perfumes: [SurveyPerfume] = []

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
  func setDatas(perfumes: [SurveyPerfume]?) {
    guard let perfumes = perfumes else { return }
    self.perfumes = perfumes
    self.reloadData()
//    print(self.perfumes)
  }
  
  func configureUI() {
    self.collectionViewLayout = self.createCompositionalLayout()
    self.translatesAutoresizingMaskIntoConstraints = false
    self.register(SurveyPerfumeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SurveyPerfumeCollectionViewCell.self))
    self.backgroundColor = .lightGray
  }
}

//extension SurveyPerfumeView: UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return self.perfumes.count
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyPerfumeCollectionViewCell.identifier, for: indexPath) as! SurveyPerfumeCollectionViewCell
//    cell.updateUI(perfume: perfumes[indexPath.row])
//    return cell
//  }
//
//}
