//
//  FilterScrollView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//
import UIKit
import SnapKit
import RxRelay

final class FilterScrollView: UIScrollView {
  
  private let viewModel: SearchFilterViewModel
  private lazy var seriesView = FilterSeriesView(viewModel: self.viewModel)
  private lazy var brandView = FilterBrandView(viewModel: self.viewModel)
  private lazy var keywordView = FilterKeywordView(viewModel: self.viewModel)

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
    let width = self.frame.width
    let height = self.frame.height

    self.contentSize = CGSize(width: width * CGFloat(3), height: 0)
    self.seriesView.frame = CGRect(x: width * CGFloat(0), y: 0, width: width, height: height)
    self.brandView.frame = CGRect(x: width * CGFloat(1), y: 0, width: width, height: height)
    self.keywordView.frame = CGRect(x: width * CGFloat(2), y: 0, width: width, height: height)
  }
  
  private func configureUI() {
    self.isPagingEnabled = true
    self.showsVerticalScrollIndicator = false
    self.showsHorizontalScrollIndicator = false

    self.addSubview(self.seriesView)
    self.addSubview(self.brandView)
    self.addSubview(self.keywordView)

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

