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
  
  
  
  
//  /// Reactive wrapper for `UITableView.insertRows(at:with:)`
//  var insertRowsEvent: ControlEvent<[IndexPath]> {
//    let source = rx.methodInvoked(#selector(UICollectionView.insertItems(at:)))
//      .map { a in
//        return a[0] as! [IndexPath]
//      }
//    return ControlEvent(events: source)
//  }
//  
//  /// Reactive wrapper for `UITableView.endUpdates()`
//  var endUpdatesEvent: ControlEvent<Bool> {
//    let source = rx.methodInvoked(#selector(UICollectionView.end .endUpdates))
//      .map { _ in
//        return true
//      }
//    return ControlEvent(events: source)
//  }
//  
//  /// Reactive wrapper for when the `UITableView` inserted rows and ended its updates.
//  var insertedItems: ControlEvent<[IndexPath]> {
//    let insertEnded = Observable.combineLatest(
//      insertRowsEvent.asObservable(),
//      endUpdatesEvent.asObservable(),
//      resultSelector: { (insertedRows: $0, endUpdates: $1) }
//    )
//    let source = insertEnded.map { $0.insertedRows }
//    return ControlEvent(events: source)
//  }
}
