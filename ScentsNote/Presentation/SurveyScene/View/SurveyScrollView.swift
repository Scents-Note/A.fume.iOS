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
  private let surveyPerfumeView = SurveyPerfumeView()
  private let surveyKeywordView = SurveyKeywordView()
  private let surveySeriesView = SurveySeriesView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
  
  
  private func configureUI() {
    let screenSize = UIScreen.main.bounds
    
    self.isPagingEnabled = true
    self.isDirectionalLockEnabled = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.showsVerticalScrollIndicator = false
    self.showsHorizontalScrollIndicator = false

    self.contentSize = CGSize(width: screenSize.width * 3, height: 592)

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

    self.surveyPerfumeView.frame = CGRect(x: screenSize.width * CGFloat(0), y: 0, width: screenSize.width, height: 476)
    self.surveyKeywordView.frame = CGRect(x: screenSize.width * CGFloat(1), y: 0, width: screenSize.width, height: 476)
    self.surveySeriesView.frame = CGRect(x: screenSize.width * CGFloat(2), y: 0, width: screenSize.width, height: 476)


    addSubview(surveyPerfumeView)
    addSubview(surveyKeywordView)
    addSubview(surveySeriesView)

  }
  
  func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
    self.surveyPerfumeView.delegate = delegate
    self.surveyPerfumeView.dataSource = delegate
    self.surveyKeywordView.delegate = delegate
    self.surveyKeywordView.dataSource = delegate
    self.surveySeriesView.delegate = delegate
    self.surveySeriesView.dataSource = delegate
  }
  
  func reload() {
    self.surveyPerfumeView.reloadData()
    self.surveyKeywordView.reloadData()
    self.surveySeriesView.reloadData()
  }
}

