//
//  UIImageView+Load.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//
import UIKit

extension UIImageView {
  
 
  func load(url: String) {
    guard let url = URL(string: url) else { return }
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}
