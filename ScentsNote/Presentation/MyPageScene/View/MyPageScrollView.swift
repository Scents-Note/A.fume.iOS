//
//  MyPageScrollView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import UIKit
import SnapKit
import RxRelay

final class MyPageScrollView: UIScrollView {
  
  private let viewModel: MyPageViewModel
  private lazy var myReviewView = MyPageReviewView(viewModel: self.viewModel)
  private lazy var myWishView = MyPageWishView(viewModel: self.viewModel)

  init(viewModel: MyPageViewModel) {
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

    self.contentSize = CGSize(width: width * CGFloat(2), height: 0)
    self.myReviewView.frame = CGRect(x: width * CGFloat(0), y: 0, width: width, height: height)
    self.myWishView.frame = CGRect(x: width * CGFloat(1), y: 0, width: width, height: height)
  }
  
  private func configureUI() {
    self.isPagingEnabled = true

    self.addSubview(self.myReviewView)
    self.addSubview(self.myWishView)
  }

  
  func updatePage(_ idx: Int) {
      self.subviews.last?.alpha = 1
      self.delegate?.scrollViewWillBeginDragging?(self)
      UIView.animate(withDuration: TimeInterval(0.3), animations: {
        switch idx {
        case 0:
          self.setContentOffset(CGPoint.zero, animated: false)
        default:
          self.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        }
      }, completion: {_ in
          self.delegate?.scrollViewDidEndDecelerating?(self)
      })
  }
}

