//
//  UICollectionView+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit

extension UICollectionView {
  
  /// Registers a particular cell using its reuse-identifier
  public func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellWithReuseIdentifier: String(describing: T.self))
  }

  /// Registers a reusable view for a specific SectionKind
  public func register<T: UICollectionReusableView>(_ reusableViewClass: T.Type, forSupplementaryViewOfKind kind: String) {
    register(reusableViewClass,
             forSupplementaryViewOfKind: kind,
             withReuseIdentifier: String(describing: T.self))
  }
  
  
  /// Generically dequeues a cell of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
  public func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(String(describing: T.self))")
    }
    return cell
  }
  
  /// Generically dequeues a header of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
  public func dequeueReusableHeaderView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }
  
  /// Generically dequeues a footer of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
  public func dequeueReusableFooterView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }
}
