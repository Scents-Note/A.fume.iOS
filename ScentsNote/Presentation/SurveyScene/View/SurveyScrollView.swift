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
  var surveyPerfumeView = SurveyPerfumeView()
  let surveyKeywordView = SurveyKeywordView()
  let surveySeriesView = SurveySeriesView()

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

    self.contentSize = CGSize(width: screenSize.width * 3, height: 0)

    self.surveyPerfumeView.frame = CGRect(x: screenSize.width * CGFloat(0), y: 0, width: screenSize.width, height: 520)
    self.surveyKeywordView.frame = CGRect(x: screenSize.width * CGFloat(1), y: 0, width: screenSize.width, height: 520)
    self.surveySeriesView.frame = CGRect(x: screenSize.width * CGFloat(2), y: 0, width: screenSize.width, height: 520)


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
  
  func updatePage(_ idx: Int) {
      self.subviews.last?.alpha = 1
      self.delegate?.scrollViewWillBeginDragging?(self)
      UIView.animate(withDuration: TimeInterval(0.3), animations: {
        if idx == 0 {
          self.setContentOffset(CGPoint.zero, animated: false)
        } else if idx == 1 {
          self.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        } else {
          self.setContentOffset(CGPoint(x: self.frame.width * 2, y: 0), animated: false)
        }
      }, completion: {_ in
          self.delegate?.scrollViewDidEndDecelerating?(self)
      })
  }
  
  func reload() {
    self.surveyPerfumeView.reloadData()
    self.surveyKeywordView.reloadData()
    self.surveySeriesView.reloadData()
  }
}

