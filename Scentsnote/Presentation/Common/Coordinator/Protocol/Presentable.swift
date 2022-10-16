//
//  Presentabl.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

protocol Presentable {
  func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
  func toPresent() -> UIViewController? {
    return self
  }
}
