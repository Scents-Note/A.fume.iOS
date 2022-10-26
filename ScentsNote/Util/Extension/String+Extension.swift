//
//  String+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation

extension String {
  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: self)
  }
  
  func isValidPassword() -> Bool {
    let passwordRegEx = "[A-Za-z0-9!_@$%^&+=]{4,}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return predicate.evaluate(with: self)
  }
}
