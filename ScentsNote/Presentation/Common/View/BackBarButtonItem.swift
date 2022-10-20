//
//  BackBarButtonItem.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import UIKit

class BackBarButtonItem: UIBarButtonItem {
  @available(iOS 14.0, *)
  override var menu: UIMenu? {
    set {
      // Don't set the menu here
      // super.menu = menu
    }
    get {
      return super.menu
    }
  }
}
