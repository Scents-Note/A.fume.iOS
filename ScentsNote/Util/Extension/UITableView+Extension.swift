//
//  UITableView+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit

extension UITableView {
  
  func register<T: UITableViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellReuseIdentifier: String(describing: T.self))
  }
  
  func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(String(describing: T.self))")
    }
    return cell
  }
}
