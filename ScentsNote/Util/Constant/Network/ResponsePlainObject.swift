//
//  ResponsePlainObject.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import Foundation

struct ResponsePlainObject {
  let message: String?
  
  enum CodingKeys: String, CodingKey {
    case message
  }
}

extension ResponsePlainObject: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    message = try? container.decode(String.self, forKey: .message)
  }
}
