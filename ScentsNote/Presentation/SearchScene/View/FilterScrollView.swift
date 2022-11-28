//
//  FilterScrollView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//
import RxRelay
import UIKit
import SnapKit

final class FilterScrollView: UIScrollView {
  
  let viewModel: SearchFilterViewModel
  lazy var seriesView = FilterSeriesView(viewModel: self.viewModel)
  lazy var brandView = FilterBrandView(viewModel: self.viewModel)
//  let keywordView = SurveyKeywordView()

  init(viewModel: SearchFilterViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let screenSize = UIScreen.main.bounds

    self.seriesView.frame = CGRect(x: screenSize.width * CGFloat(0), y: 0, width: screenSize.width, height: self.frame.height)
    self.brandView.frame = CGRect(x: screenSize.width * CGFloat(1), y: 0, width: screenSize.width, height: self.frame.height)
    
    
  }
  
  private func configureUI() {
    let screenSize = UIScreen.main.bounds
    self.isPagingEnabled = true
    self.isDirectionalLockEnabled = true
    self.showsVerticalScrollIndicator = false
    self.showsHorizontalScrollIndicator = false

    self.contentSize = CGSize(width: screenSize.width * 2, height: 0)
    
//    self.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
//    self.surveyKeywordView.frame = CGRect(x: screenSize.width * CGFloat(1), y: 0, width: screenSize.width, height: 520)
//    self.surveySeriesView.frame = CGRect(x: screenSize.width * CGFloat(2), y: 0, width: screenSize.width, height: 520)


    self.addSubview(self.seriesView)
    self.addSubview(self.brandView)
//    addSubview(surveySeriesView)

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
}

