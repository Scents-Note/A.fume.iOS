//
//  UIFont+Custom.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

extension UIFont {
  enum notoSansType: String {
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
  }
  
  enum nanumMyeongjoType: String {
    case regular = ""
    case extraBold = "ExtraBold"
    case bold = "Bold"
  }
  
  static func notosans(type: notoSansType = .regular, size: CGFloat = 14) -> UIFont {
    return UIFont(name: "NotoSansCJKkr-\(type.rawValue)", size: size)!
  }
  
  static func nanumMyeongjo(type: nanumMyeongjoType = .regular, size: CGFloat = 14) -> UIFont {
    return UIFont(name: "NanumMyeongjo\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
}
