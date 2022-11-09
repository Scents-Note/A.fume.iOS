//
//  RecommendPerfumeSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import RxSwift
import Then

final class HomeRecommendationSection: UICollectionViewCell {
  
  private let collectionView: UICollectionView
  private let flowLayout = UICollectionViewFlowLayout()
  private let pageControl = UIPageControl().then {
    $0.currentPageIndicatorTintColor = .bgSurveySelected
    $0.pageIndicatorTintColor = .bgTabBar
    $0.allowsContinuousInteraction = false
  }

  // MARK: Model
  private var perfumes: [Perfume] = []
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  override init(frame: CGRect) {
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    super.init(frame: frame)
    self.configureUI()
    
    self.backgroundColor = .white
    
    
  }
  
  private func configureUI() {
    self.flowLayout.scrollDirection = .horizontal
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = false
    
    self.collectionView.decelerationRate = .fast
    self.collectionView.register(HomeRecommendationCell.self)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    
    self.contentView.addSubview(self.collectionView)
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.collectionView.snp.makeConstraints {
      $0.top.equalToSuperview()
//      $0.left.equalToSuperview().offset(120)
      $0.right.equalToSuperview()
      $0.width.equalTo(HomeRecommendationCell.width)
    }
    
    
    self.contentView.addSubview(self.pageControl)
    self.pageControl.snp.makeConstraints {
      $0.top.equalTo(self.collectionView.snp.bottom).offset(4)
      $0.bottom.equalToSuperview()
      $0.left.equalTo(self.collectionView.snp.left)
    }
  }
  
  func updateUI(perfumes: [Perfume]?) {
    guard let perfumes = perfumes else { return }
    self.perfumes = perfumes
    print("User Log: hihi")
    self.pageControl.numberOfPages = perfumes.count

    self.setNeedsLayout()
    self.collectionView.reloadData()
    //    self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
  }
  
}

extension HomeRecommendationSection: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.perfumes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(HomeRecommendationCell.self, for: indexPath)
    cell.updateUI(perfume: self.perfumes[indexPath.row])
    return cell
  }
}

extension HomeRecommendationSection: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: HomeRecommendationCell.width, height: HomeRecommendationCell.height)
  }
}

extension HomeRecommendationSection: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {    
    let cellWidth = HomeRecommendationCell.width
    
    let estimatedIndex = scrollView.contentOffset.x / cellWidth
    let index: Int
    if velocity.x > 0 {
      index = Int(ceil(estimatedIndex))
    } else if velocity.x < 0 {
      index = Int(floor(estimatedIndex))
    } else {
      index = Int(round(estimatedIndex))
    }
    self.pageControl.currentPage = index
    
    targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidth, y: 0)
    
    
  }
}
