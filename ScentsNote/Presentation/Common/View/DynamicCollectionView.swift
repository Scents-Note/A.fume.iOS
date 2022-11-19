//
//  DynamicCollectionView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit


class DynamicCollectionView: UICollectionView {
  override func layoutSubviews() {
    super.layoutSubviews()
    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return contentSize
  }
}
