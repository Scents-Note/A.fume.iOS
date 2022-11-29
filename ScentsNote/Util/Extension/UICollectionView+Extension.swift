//
//  UICollectionView+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellWithReuseIdentifier: String(describing: T.self))
  }
  
  func register<T: UICollectionReusableView>(_ reusableViewClass: T.Type, forSupplementaryViewOfKind kind: String) {
    register(reusableViewClass,
             forSupplementaryViewOfKind: kind,
             withReuseIdentifier: String(describing: T.self))
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(String(describing: T.self))")
    }
    return cell
  }
  
  func dequeueReusableHeaderView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }
  
  func dequeueReusableFooterView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }
}
