//
//  PerfumeDetailScrollView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/16.
//

import UIKit
import SnapKit

final class PerfumeDetailScrollView: UIScrollView {
  
  private var isConfigureUI = false
  private let contentView = UIView()
  var perfumeDetailInfoView = PerfumeDetailInfoView()
  let perfumeDetailReviewView = PerfumeDetailReviewView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
  private func configureUI() {
    let screenWidth = UIScreen.main.bounds.width
    
    self.isPagingEnabled = true
    self.isDirectionalLockEnabled = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.showsVerticalScrollIndicator = false
    self.showsHorizontalScrollIndicator = false

    self.contentSize = CGSize(width: screenWidth * 2, height: 6000)

    self.perfumeDetailInfoView.frame = CGRect(x: screenWidth * CGFloat(0), y: 0, width: screenWidth, height: 6000)
    self.perfumeDetailReviewView.frame = CGRect(x: screenWidth * CGFloat(1), y: 0, width: screenWidth, height: 6000)

    self.addSubview(perfumeDetailInfoView)
    self.addSubview(perfumeDetailReviewView)

  }
  
  func updateUI(perfumeDetail: PerfumeDetail) {
    self.perfumeDetailInfoView.updateSnapshot(perfumeDetail: perfumeDetail)
  }
  
//  func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
//    self.surveyPerfumeView.delegate = delegate
//    self.surveyPerfumeView.dataSource = delegate
//    self.surveyKeywordView.delegate = delegate
//    self.surveyKeywordView.dataSource = delegate
//    self.surveySeriesView.delegate = delegate
//    self.surveySeriesView.dataSource = delegate
//  }
//
//  func updatePage(_ idx: Int) {
//      self.subviews.last?.alpha = 1
//      self.delegate?.scrollViewWillBeginDragging?(self)
//      UIView.animate(withDuration: TimeInterval(0.3), animations: {
//        if idx == 0 {
//          self.setContentOffset(CGPoint.zero, animated: false)
//        } else if idx == 1 {
//          self.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
//        } else {
//          self.setContentOffset(CGPoint(x: self.frame.width * 2, y: 0), animated: false)
//        }
//      }, completion: {_ in
//          self.delegate?.scrollViewDidEndDecelerating?(self)
//      })
//  }
//
//  func reload() {
//    self.surveyPerfumeView.reloadData()
//    self.surveyKeywordView.reloadData()
//  }
}



