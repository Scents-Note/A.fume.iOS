//
//  SurveyScrollView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit
import SnapKit

final class SurveyScrollView: UIScrollView {
  
  private var isConfigureUI = false
  private let contentView = UIView()
  private let surveySeriesView = SurveySeriesView()
  private let surveySeriesView2 = SurveySeriesView()
  private let emptyview1 = UIView()
  private let emptyview2 = UIView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
  
  
  private func configureUI() {
    let twice: CGFloat = 2
    let screenSize = UIScreen.main.bounds
    
    self.showsVerticalScrollIndicator = false
    self.isPagingEnabled = true
    self.isDirectionalLockEnabled = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.showsHorizontalScrollIndicator = false

    self.contentSize = CGSize(width: screenSize.width * twice, height: 592)

//    self.addSubview(self.contentView)
//    self.contentView.snp.makeConstraints {
//      $0.edges.equalTo(self.contentLayoutGuide)
//      $0.width.equalTo(self.frameLayoutGuide).multipliedBy(0.5)
//    }
//    print("user log: \(self.inputView)")
//    let a = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 592))
//    a.backgroundColor = .blue
//    let b = UIView(frame: CGRect(x: screenSize.width, y: 0, width: screenSize.width, height: 592))
//    b.backgroundColor = .gray
//    addSubview(a)
//    addSubview(b)
    
//    self.contentSize = CGSize(width: screenSize.width * twice, height: screenSize.width)

    self.surveySeriesView.frame = CGRect(x: screenSize.width * CGFloat(0), y: 0, width: screenSize.width, height: 592)
    self.surveySeriesView2.frame = CGRect(x: screenSize.width * CGFloat(1), y: 0, width: screenSize.width, height: 592)

    addSubview(surveySeriesView)
    addSubview(surveySeriesView2)
  }
  
  func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
    self.surveySeriesView.delegate = delegate
    self.surveySeriesView.dataSource = delegate
    self.surveySeriesView2.delegate = delegate
    self.surveySeriesView2.dataSource = delegate
  }
  
  func reload() {
    print("reload")
    self.surveySeriesView.reloadData()
    self.surveySeriesView2.reloadData()

  }
  //  private lazy var stationResultCollectionView: UICollectionView = {
  //      let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
  //      collectionView.backgroundColor = BBusColor.bbusLightGray
  //      collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
  //      collectionView.register(SimpleCollectionHeaderView.self,
  //                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
  //                              withReuseIdentifier: SimpleCollectionHeaderView.identifier)
  //      return collectionView
  //  }()
}

