//
//  UIFont+Custom.swift
//  ScentsNote
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
    
    enum AppleSDGothicNeoType: String {
        case regular = "Regular"
        case medium = "Medium"
        case bold = "Bold"
    }
  
  static func notoSans(type: notoSansType, size: CGFloat) -> UIFont {
    return UIFont(name: "NotoSansCJKkr-\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  static func nanumMyeongjo(type: nanumMyeongjoType, size: CGFloat) -> UIFont {
    return UIFont(name: "NanumMyeongjoOTF\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
  }
    
    static func appleSDGothic(type: AppleSDGothicNeoType, size: CGFloat) -> UIFont {
      return UIFont(name: "AppleSDGothicNeo-\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
  
}
